//
//  ProjectEditorViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 29.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectEditorViewController.h"
#import "SKBindingManager.h"
#import "CustomAlertView.h"
#import "CKCalendarView.h"
#import "ProjectsViewController.h"
#import "DocumentHandler.h"
#import "ProjectSession+Create.h"
#import "ProjectsViewController.h"
#import "Project.h"
#import "UIView+Frame.h"
#import "UIColor+Create.h"
#import "BillingPoint.h"

#define ALERT_DISCARD 11
#define ALERT_SAVE 12

typedef enum {
    ProjectEditorModeAdd,
    ProjectEditorModeEdit
} ProjectEditorMode;

@interface ProjectEditorViewController ()
@property (weak, nonatomic) IBOutlet UIView *projectNameHolder;
@property (weak, nonatomic) IBOutlet UIView *sessionTimeHolder;
@property (weak, nonatomic) IBOutlet UIView *sessionDateHolder;
@property (weak, nonatomic) IBOutlet UIView *sessionNoteHolder;

@property (weak, nonatomic) IBOutlet UITextView *sessionNoteTextView;
@property (weak, nonatomic) IBOutlet UITextField *projectNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *accpetButton;

@property (nonatomic, strong) SKBindingManager *bindingManager;
@property (nonatomic, assign) ProjectEditorMode projectEditorMode;

@property (nonatomic, assign) BOOL changeOccured;

@end

@implementation ProjectEditorViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bindingManager = [[SKBindingManager alloc] init];
    self.changeOccured = NO;
    
    if (self.projectSession == nil) {
        self.projectEditorMode = ProjectEditorModeAdd;
        [self.navigation setTitle:@"Add work"];
        self.projectSession = [NSMutableDictionary dictionary];

    } else {
        [self.navigation setTitle:@"Edit work"];
        self.projectEditorMode = ProjectEditorModeEdit;
        NSAssert(self.projectSession, @"You should set project session to edit, when in edit mode");
    
    }
    
    [self.navigation setLeftButtonImage:@"cancel_button"];
    [self.navigation setRightButtonImage:@"accept_button"];
    
    [self.navigation setLeftButtonTarget:self action:@selector(discard:)];
    [self.navigation setRightButtonTarget:self action:@selector(saveChanges:)];
    
    //bind fields to model
    [self bind];
    
    //set inputAccessory view for note
    self.sessionNoteTextView.inputAccessoryView = [self inputAccessoryViewForNote];
    
    //set font
    self.timeLabel.font = GOTHAM_FONT(17);
    self.dateLabel.font = GOTHAM_FONT(17);
    
    //register for notifications from UIKeyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - keyboard handling

- (void)hideKeyoardIfShown {
    if ([self.sessionNoteTextView isFirstResponder]) {
        
        [self.sessionNoteTextView resignFirstResponder];
        
    } else if ([self.projectTimeTextField isFirstResponder]) {
        
        [self.projectTimeTextField resignFirstResponder];
        
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ([self.sessionNoteTextView isFirstResponder]) {
        
        [self openProjectDescription:duration];
        
    } else if ([self.projectTimeTextField isFirstResponder]) {
        
        [self openProjectTime:duration];
        
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ([self.sessionNoteTextView isFirstResponder]) {
        
        [self closeProjectDescription:duration];
        
    } else if ([self.projectTimeTextField isFirstResponder]) {
        
        [self closeProjectTime:duration];
        
    }
}

- (void)openProjectDescription:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.projectNameHolder.alpha = 0;
        self.sessionTimeHolder.alpha = 0;
        self.sessionDateHolder.alpha = 0;
        self.navigation.leftButton.alpha = 0;
        
        CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.sessionNoteHolder.frame) - 15 - 45));
        self.sessionNoteHolder.transform = t2;
        [self.sessionNoteTextView setHeight:self.sessionNoteTextView.frame.size.height - self.sessionNoteTextView.inputAccessoryView.frame.size.height];
        [self.sessionNoteHolder setHeight:self.sessionNoteHolder.frame.size.height - self.sessionNoteTextView.inputAccessoryView.frame.size.height];
    }];
    
}

- (void)closeProjectDescription:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sessionNoteHolder.transform = CGAffineTransformIdentity;
        [self.sessionNoteTextView setHeight:self.sessionNoteTextView.frame.size.height + self.sessionNoteTextView.inputAccessoryView.frame.size.height];
        [self.sessionNoteHolder setHeight:self.sessionNoteHolder.frame.size.height + self.sessionNoteTextView.inputAccessoryView.frame.size.height];
        
        self.projectNameHolder.alpha = 1;
        self.sessionTimeHolder.alpha = 1;
        self.sessionDateHolder.alpha = 1;
        self.navigation.leftButton.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)openProjectTime:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        
        self.projectNameHolder.alpha = 0;
        self.sessionNoteHolder.alpha = 0;
        self.sessionDateHolder.alpha = 0;
        self.navigation.leftButton.alpha = 0;
        
        self.sessionTimeHolder.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.sessionTimeHolder.frame) - 120));
        
    }];
}

- (void)closeProjectTime:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sessionTimeHolder.transform = CGAffineTransformIdentity;
        
        self.navigation.leftButton.alpha = 1;
        self.projectNameHolder.alpha = 1;
        self.sessionNoteHolder.alpha = 1;
        self.sessionDateHolder.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.projectTimeTextField resignFirstResponder];
    return NO;
}

#pragma mark - navigation bar actions

- (IBAction)saveChanges:(UIButton *)sender {
    
    if ([self.sessionNoteTextView isFirstResponder]) {
        
        [self.sessionNoteTextView resignFirstResponder];
        return;
        
    } else if ([self.projectTimeTextField isFirstResponder]) {
        
        [self.projectTimeTextField resignFirstResponder];
        return;
        
    } else {
        
        [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            if (self.projectEditorMode == ProjectEditorModeAdd) {
                self.projectSession = [ProjectSession createLocallyWithData:self.projectSession inContext:document.managedObjectContext];
            }
            
            [ProjectSession updateHeights:self.projectSession];
            
            [document.managedObjectContext save:nil];
            
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {

                CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"accept_button" title:@"Save" subtitle:@"Your changes have been succesfully saved" discard:@"" confirm:@"Ok"];
                
                alertView.delegate = self;
                [alertView show];
            
            }];
        }];
    
    }
    
}

- (IBAction)discard:(UIButton *)sender {
    
    [self hideKeyoardIfShown];
    
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Discard?" subtitle:@"Do you really want to discard changes?" discard:@"No" confirm:@"Discard"];
    
    alertView.tag = ALERT_DISCARD;
    alertView.delegate = self;
    if (self.changeOccured) {
        [alertView show];
    } else {
        [self customAlertViewConfirmed:alertView];
    }
}

#pragma mark - form actions

- (IBAction)chooseProject:(UIButton *)sender {
    [self performSegueWithIdentifier:@"openProjects" sender:self];
}

- (IBAction)chooseDate:(UIButton *)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(10, 90, 300, 300)];
    calendar.delegate = self;
    
    NSDate *selectedDate = nil;
    if ([self.projectSession isKindOfClass:[NSMutableDictionary class]]) {
        
        selectedDate = [self.projectSession objectForKey:@"sessionDate"];
        
    } else if ([self.projectSession isKindOfClass:[ProjectSession class]]) {
        
        selectedDate = ((ProjectSession *)self.projectSession).sessionDate;
        
    }
    
    if (selectedDate) calendar.selectedDate = selectedDate;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.window.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.8;
    
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.window.frame];
    overlayView.backgroundColor = [UIColor clearColor];
    overlayView.alpha = 0;
    
    [overlayView addSubview:backgroundView];
    [overlayView addSubview:calendar];
    
    [self.view addSubview:overlayView];
    
    //add gesture to close calendar
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(closeCalendar:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [backgroundView addGestureRecognizer:tapGestureRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 1;
    }];
}

- (IBAction)chooseTime:(UIButton *)sender {
    
    [self.projectTimeTextField becomeFirstResponder];
    
}

#pragma mark - binding creation

- (void)bind {

    //create binding options dictionary which contains all properties needed for binding
    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"projectNameBinding"     forKey:BindingId];
    [bindingOptions setObject:self.projectSession       forKey:BindingFrom];
    [bindingOptions setObject:@"billingPoint"                forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectNameLabel     forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextField  forKey:BindingToKeyPath];
    [bindingOptions setObject:@NO                       forKey:BindingTwoWayBinding];
    
    SKTransformationBlock transformationProject = ^(id value, id toObject) {
        return ((BillingPoint *)value).billingPointFullName;
    };
    [bindingOptions setObject:transformationProject     forKey:BindingForwardTransformation];
    
    [self.bindingManager bind:bindingOptions];
    
    //new
    bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"projectDateBinding"     forKey:BindingId];
    [bindingOptions setObject:self.projectSession       forKey:BindingFrom];
    [bindingOptions setObject:@"sessionDate"            forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectDateLabel     forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextView   forKey:BindingToKeyPath];
    
    SKTransformationBlock transformation = ^(id value, id toObject) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd.MM.yyyy.";
        return [formatter stringFromDate:value];
    };
    [bindingOptions setObject:transformation            forKey:BindingForwardTransformation];
    [bindingOptions setObject:@NO                       forKey:BindingTwoWayBinding];
    
    [self.bindingManager bind:bindingOptions];
    
    
//    //new
    bindingOptions = [NSMutableDictionary dictionary];
    [bindingOptions setObject:@"projectTimeBinding" forKey:BindingId];
    [bindingOptions setObject:self.projectSession forKey:BindingFrom];
    [bindingOptions setObject:@"sessionTime" forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectTimeTextField forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextField forKey:BindingToKeyPath];
    
    SKTransformationBlock transformationTime = ^(id value, id toObject) {

        NSInteger time = [[((NSString *)value) stringByReplacingOccurrencesOfString:@":" withString:@""] intValue];
        
        if (time > 2400) {
            time /= 10;
        }
        
        NSInteger minutes = time % 100;
        NSInteger hours = time/100;
        
        self.projectTimeTextField.text = [NSString stringWithFormat:@"%02d:%02d",hours,minutes];
        
        return [@"- " stringByAppendingString:self.projectTimeTextField.text];
    };
    [bindingOptions setObject:transformationTime forKey:BindingBackwardTransformation];
    
    SKTransformationBlock transformationProjectF = ^(id value, id toObject) {
        return [((NSString *)value) stringByReplacingOccurrencesOfString:@"- " withString:@""];
    };
    [bindingOptions setObject:transformationProjectF forKey:BindingForwardTransformation];
    [bindingOptions setObject:@YES forKey:BindingTwoWayBinding];
    
    [self.bindingManager bind:bindingOptions];
    
    bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"projectNoteBinding"     forKey:BindingId];
    [bindingOptions setObject:self.projectSession       forKey:BindingFrom];
    [bindingOptions setObject:@"sessionNote"            forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.sessionNoteTextView  forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextField  forKey:BindingToKeyPath];
    [bindingOptions setObject:@YES                       forKey:BindingTwoWayBinding];
    [self.bindingManager bind:bindingOptions];
    
    self.bindingManager.delegate = self;
    
}

#pragma mark - Custom alert view delegate

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    
    [self.bindingManager deactivateAllBindings];
    [self.bindingManager removeAllBindings];
    self.bindingManager = nil;
    
    if (alertView.tag == ALERT_DISCARD) {
        [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            if (self.projectEditorMode == ProjectEditorModeEdit) {
                [document.managedObjectContext rollback];
            }
            
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];    
    }
}

- (void)viewDidUnload {
    [self setCloseButton:nil];
    [self setAccpetButton:nil];
    [self setTimeLabel:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {

    if ([self.projectSession isKindOfClass:[NSMutableDictionary class]]) {
  
        [self.projectSession setObject:date forKey:@"sessionDate"];
    
    } else if ([self.projectSession isKindOfClass:[ProjectSession class]]) {
        
        ((ProjectSession *)self.projectSession).sessionDate = date;
    
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        calendar.superview.alpha = 0.;
    } completion:^(BOOL finished) {
        [calendar.superview removeFromSuperview];
    }];
}

- (void)closeCalendar:(UITapGestureRecognizer *)tapGesture {
    [UIView animateWithDuration:0.3 animations:^{
        tapGesture.view.superview.alpha = 0.;
    } completion:^(BOOL finished) {
        [tapGesture.view.superview removeFromSuperview];
    }];
}

#pragma mark - performing for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openProjects"]) {
        [(ProjectsViewController *)segue.destinationViewController setSession:self.projectSession];
    }
}

#pragma mark - binding delegate

- (void)bindedObject:(id)object changedKeyPath:(NSString *)keyPath {
    self.changeOccured = YES;
}

#pragma mark - Input view for note

- (UIView *)inputAccessoryViewForNote {
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    inputView.backgroundColor = [UIColor clearColor];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    separator.backgroundColor = [UIColor withRed:199 green:199 blue:199 alpha:1];
    
    UIButton *buttonStar = [[UIButton alloc] initWithFrame:CGRectMake(276, 0, 44, 60)];
    buttonStar.titleLabel.font = GOTHAM_FONT(20);
    [buttonStar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonStar setTitle:@"*" forState:UIControlStateNormal];
    [buttonStar addTarget:self action:@selector(starTouched:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *buttonDoubleStar = [[UIButton alloc] initWithFrame:CGRectMake(276, 0, 44, 60)];
//    buttonDoubleStar.titleLabel.font = GOTHAM_FONT(20);
//    [buttonDoubleStar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [buttonDoubleStar setTitle:@"**" forState:UIControlStateNormal];
//    [buttonDoubleStar addTarget:self action:@selector(starTouched:) forControlEvents:UIControlEventTouchUpInside];
//    
    [inputView addSubview:separator];
    [inputView addSubview:buttonStar];
//    [inputView addSubview:buttonDoubleStar];
    
    return inputView;
    
}

- (void)starTouched:(UIButton *)button {
    
    NSString *newString;

    if ([button.titleLabel.text isEqualToString:@"*"]) {
        newString = [self.sessionNoteTextView.text stringByAppendingString:@"* "];
    }
    
    self.sessionNoteTextView.text = newString;
    
}

@end
