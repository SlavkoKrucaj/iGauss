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

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *accpetButton;

@property (nonatomic, strong) SKBindingManager *bindingManager;
@property (nonatomic, assign) ProjectEditorMode projectEditorMode;

@end

@implementation ProjectEditorViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bindingManager = [[SKBindingManager alloc] init];
    
    if (self.projectSession == nil) {
        self.projectEditorMode = ProjectEditorModeAdd;

        self.projectSession = [NSMutableDictionary dictionary];

    } else {
    
        self.projectEditorMode = ProjectEditorModeEdit;
        NSAssert(self.projectSession, @"You should set project session to edit, when in edit mode");
    
    }
    [self bind];
    
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

- (void)dealloc {
    [self.bindingManager removeAllBindings];
}

#pragma mark - keyboard handling

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
        self.closeButton.alpha = 0;
        
        CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.sessionNoteHolder.frame) - 15 - 45));
        self.sessionNoteHolder.transform = t2;
        
    }];
    
}

- (void)closeProjectDescription:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sessionNoteHolder.transform = CGAffineTransformIdentity;
        
        self.projectNameHolder.alpha = 1;
        self.sessionTimeHolder.alpha = 1;
        self.sessionDateHolder.alpha = 1;
        self.closeButton.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)openProjectTime:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        
        self.projectNameHolder.alpha = 0;
        self.sessionNoteHolder.alpha = 0;
        self.sessionDateHolder.alpha = 0;
        self.closeButton.alpha = 0;
        
        self.sessionTimeHolder.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.sessionTimeHolder.frame) - 120));
        
    }];
}

- (void)closeProjectTime:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sessionTimeHolder.transform = CGAffineTransformIdentity;
        
        self.closeButton.alpha = 1;
        self.projectNameHolder.alpha = 1;
        self.sessionNoteHolder.alpha = 1;
        self.sessionDateHolder.alpha = 1;
        
    } completion:^(BOOL finished) {
    }];
    
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
        
        CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"accept_button" title:@"Save" subtitle:@"Your changes have been succesfully saved" discard:@"" confirm:@"Ok"];
        
        alertView.delegate = self;
        [alertView show];
        
    }
    
}

- (IBAction)discard:(UIButton *)sender {
    
    NSLog(@"%@", self.projectSession);
//    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
//        if (self.projectEditorMode == ProjectEditorModeAdd) {
//            [document.managedObjectContext deleteObject:self.projectSession];
//        } else {
//            [document.managedObjectContext rollback];
//        }
//    }];
    
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Discard?" subtitle:@"Do you really want to discard changes?" discard:@"No" confirm:@"Discard"];
    
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - form actions

- (IBAction)chooseProject:(UIButton *)sender {
    [self performSegueWithIdentifier:@"openProjects" sender:self];
}

- (IBAction)chooseDate:(UIButton *)sender {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(10, 90, 300, 300)];
    calendar.alpha = 0;
    [self.view addSubview:calendar];
    calendar.delegate = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        calendar.alpha = 1.;
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
    [bindingOptions setObject:@"project"                forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectNameLabel     forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextField  forKey:BindingToKeyPath];
    [bindingOptions setObject:@NO                       forKey:BindingTwoWayBinding];
    
    SKTransformationBlock transformationProject = ^(id value, id toObject) {
        return ((Project *)value).projectFullName;
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
    
}

#pragma mark - Custom alert view delegate

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setCloseButton:nil];
    [self setAccpetButton:nil];
    [super viewDidUnload];
}

#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    [self.projectSession setObject:date forKey:@"sessionDate"];// = date;
    
    [UIView animateWithDuration:0.3 animations:^{
        calendar.alpha = 0.;
    } completion:^(BOOL finished) {
        [calendar removeFromSuperview];
    }];
}

#pragma mark - performing for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"openProjects"]) {
        [(ProjectsViewController *)segue.destinationViewController setSession:self.projectSession];
    }
}

@end
