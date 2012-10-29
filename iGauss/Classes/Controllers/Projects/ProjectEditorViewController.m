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

@interface ProjectEditorViewController ()
@property (weak, nonatomic) IBOutlet UIView *projectNameHolder;
@property (weak, nonatomic) IBOutlet UITextView *sessionNoteTextView;
@property (weak, nonatomic) IBOutlet UIView *sessionTimeHolder;
@property (weak, nonatomic) IBOutlet UIView *sessionDateHolder;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectTimeTextField;
@property (weak, nonatomic) IBOutlet UILabel *projectDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *accpetButton;

@property (nonatomic, strong) SKBindingManager *bindingManager;
@end

@implementation ProjectEditorViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bindingManager = [[SKBindingManager alloc] init];
    
//    [self bind];
    
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
        
        CGAffineTransform t1 = CGAffineTransformScale(CGAffineTransformIdentity, 310./280, 190./166);
        CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.sessionNoteTextView.frame) - 60));
        self.sessionNoteTextView.transform = CGAffineTransformConcat(t1, t2);
        
    }];
    
}

- (void)closeProjectDescription:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.sessionNoteTextView.transform = CGAffineTransformIdentity;
        
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
        self.sessionNoteTextView.alpha = 0;
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
        self.sessionNoteTextView.alpha = 1;
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
    
    [bindingOptions setObject:@"projectNameBinding" forKey:BindingId];
    [bindingOptions setObject:self.projectSession   forKey:BindingFrom];
    [bindingOptions setObject:@"project"            forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectNameLabel forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyLabel  forKey:BindingToKeyPath];
    [bindingOptions setObject:@NO                   forKey:BindingTwoWayBinding];
    
    [self.bindingManager bind:bindingOptions];
    
    //new
    bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"projectDateBinding" forKey:BindingId];
    [bindingOptions setObject:self.projectSession   forKey:BindingFrom];
    [bindingOptions setObject:@"sessionDate"        forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectDateLabel forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyLabel  forKey:BindingToKeyPath];
    
    SKTransformationBlock transformation = ^(id value, id toObject) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd.MM.yyyy.";
        return [formatter stringFromDate:value];
    };
    [bindingOptions setObject:transformation        forKey:BindingForwardTransformation];
    [bindingOptions setObject:@NO                   forKey:BindingTwoWayBinding];
    
    [self.bindingManager bind:bindingOptions];
    
    
    //new
    bindingOptions = [NSMutableDictionary dictionary];
    [bindingOptions setObject:@"projectTimeBinding" forKey:BindingId];
    [bindingOptions setObject:self.projectSession forKey:BindingFrom];
    [bindingOptions setObject:@"sessionTime" forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.projectTimeTextField forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyTextField forKey:BindingToKeyPath];
    
    //    SKTransformationBlock transformationTime = ^(id value, id toObject) {
    //        NSString *newString = (NSString *)value;
    //        NSString *oldString = (NSString *)[toObject valueForKey:@"time"];
    //
    //        if (!oldString || [oldString isEqualToString:@""]) oldString = @"00:00";
    //
    //        NSArray components = [oldString componentsSeparatedByString:@":"];
    //        NSInteger minutes = [components objectAtIndex:0] * 60 + [components objectAtIndex:1] + last;
    //
    //        return newString;
    //    };
    //    [bindingOptions setObject:transformationTime forKey:BindingBackwardTransformation];
    [bindingOptions setObject:@NO forKey:BindingTwoWayBinding];
    
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
    
    self.projectSession.sessionDate = date;
    
    [UIView animateWithDuration:0.3 animations:^{
        calendar.alpha = 0.;
    } completion:^(BOOL finished) {
        [calendar removeFromSuperview];
    }];
}

@end
