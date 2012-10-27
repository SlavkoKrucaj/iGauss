//
//  WorkViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "WorkViewController.h"
#import "SKBindingManager.h"
#import "ProjectsViewController.h"
#import "WorkDay.h"
#import "Work.h"
#import "Sources.h"
#import "Source.h"

@interface WorkViewController ()
@property (nonatomic, strong) SKBindingManager *bindingManager;
@property (nonatomic, strong) Work *projectModel;

@property (weak, nonatomic) IBOutlet UIView *projectNameHolder;
@property (weak, nonatomic) IBOutlet UIView *projectTimeHolder;
@property (weak, nonatomic) IBOutlet UIView *projectDateHolder;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectTime;
@property (weak, nonatomic) IBOutlet UILabel *projectDate;
@property (weak, nonatomic) IBOutlet UITextView *projectDescription;

@property (weak, nonatomic) IBOutlet UILabel *screenTitle;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@property (nonatomic, strong) Source *projectsSource;
@end

@implementation WorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bindingManager = [[SKBindingManager alloc] init];
    self.projectModel = [[Work alloc] init];
    
    //create binding options dictionary which contains all properties needed for binding
    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"projectNameBinding" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.projectModel forKey:BindingFrom];
    [bindingOptions setObject:@"project" forKey:BindingFromKeyPath];
    
    //set object and propety - from
    [bindingOptions setObject:self.projectNameLabel forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyLabel forKey:BindingToKeyPath];
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:NO] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];
    
    bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"projectDateBinding" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.projectModel forKey:BindingFrom];
    [bindingOptions setObject:@"date" forKey:BindingFromKeyPath];
    
    //set object and propety - from
    [bindingOptions setObject:self.projectDate forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyLabel forKey:BindingToKeyPath];
    
    SKTransformationBlock transformation = ^(id value, id toObject) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd.MM.yyyy.";
        return [formatter stringFromDate:value];
    };
    [bindingOptions setObject:transformation forKey:BindingForwardTransformation];
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:NO] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];
    
    bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"projectTimeBinding" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.projectModel forKey:BindingFrom];
    [bindingOptions setObject:@"time" forKey:BindingFromKeyPath];
    
    //set object and propety - from
    [bindingOptions setObject:self.projectTime forKey:BindingTo];
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
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:YES] forKey:BindingTwoWayBinding];

    //add binding
    [self.bindingManager bind:bindingOptions];

#warning provjera ako je prazno onda postavi
    self.projectModel.project = @"Choose project";
    self.projectModel.date = [NSDate date];
    
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

- (void)viewWillDisppear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //remove observers from UIKeyboard
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)dealloc {
    [self.bindingManager removeAllBindings];
}

- (IBAction)discardScreen:(UIButton *)sender {
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Discard?" subtitle:@"Do you really want to discard changes?" discard:@"No" confirm:@"Discard"];

    alertView.delegate = self;
    [alertView show];
}

- (IBAction)saveWork:(id)sender {
    if ([self.projectDescription isFirstResponder]) {
    
        [self.projectDescription resignFirstResponder];
        return;
        
    } else if ([self.projectTime isFirstResponder]) {
    
        [self.projectTime resignFirstResponder];
        return;
        
    } else {
    
        CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"accept_button" title:@"Save" subtitle:@"Your changes have been succesfully saved" discard:@"" confirm:@"Ok"];
        
        alertView.delegate = self;
        [alertView show];

    }
}

#pragma mark - Alert delegates

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:YES];
    [alertView dismiss];
}

#pragma mark Work actions

- (IBAction)chooseProject:(UIButton *)sender {
    self.projectsSource = [Sources createProjectsSource];
    self.projectsSource.delegate = self;
    [self.projectsSource loadAsync];
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
    
    [self.projectTime becomeFirstResponder];
    
}
#pragma mark - Calendar delegate

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
//    self.projectModel.projectDate = date;
    
    [UIView animateWithDuration:0.3 animations:^{
        calendar.alpha = 0.;
    } completion:^(BOOL finished) {
        [calendar removeFromSuperview];
    }];
}

#pragma mark - prepare for Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseProject"]) {
        [segue.destinationViewController setModel:self.projectModel];
        [segue.destinationViewController setProjects:sender];
    }
}

#pragma mark - Keyboard on/off

- (void)keyboardWillShow:(NSNotification *)notification {
    
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if ([self.projectDescription isFirstResponder]) {
    
        [self openProjectDescription:duration];
        
    } else if ([self.projectTime isFirstResponder]) {
    
        [self openProjectTime:duration];
        
    }
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if ([self.projectDescription isFirstResponder]) {
        
        [self closeProjectDescription:duration];
        
    } else if ([self.projectTime isFirstResponder]) {
        
        [self closeProjectTime:duration];
        
    }
}

- (void)openProjectDescription:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        self.projectNameHolder.alpha = 0;
        self.projectTimeHolder.alpha = 0;
        self.projectDateHolder.alpha = 0;
        self.closeButton.alpha = 0;
        
        CGAffineTransform t1 = CGAffineTransformScale(CGAffineTransformIdentity, 310./280, 190./166);
        CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.projectDescription.frame) - 60));
        self.projectDescription.transform = CGAffineTransformConcat(t1, t2);
        
    }];

}

- (void)closeProjectDescription:(CGFloat)duration {

    [UIView animateWithDuration:duration animations:^{

        self.projectDescription.transform = CGAffineTransformIdentity;

        self.closeButton.alpha = 1;
        self.projectNameHolder.alpha = 1;
        self.projectTimeHolder.alpha = 1;
        self.projectDateHolder.alpha = 1;
   
    } completion:^(BOOL finished) {
    }];
    
}

- (void)openProjectTime:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        
        self.projectNameHolder.alpha = 0;
        self.projectDescription.alpha = 0;
        self.projectDateHolder.alpha = 0;
        self.closeButton.alpha = 0;
        
       self.projectTimeHolder.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(CGRectGetMinY(self.projectTimeHolder.frame) - 120));
        
    }];
}

- (void)closeProjectTime:(CGFloat)duration {
    
    [UIView animateWithDuration:duration animations:^{
        
        self.projectTimeHolder.transform = CGAffineTransformIdentity;
        
        self.closeButton.alpha = 1;
        self.projectNameHolder.alpha = 1;
        self.projectDescription.alpha = 1;
        self.projectDateHolder.alpha = 1;

    } completion:^(BOOL finished) {
    }];
    
}

#pragma mark - Source delegate

- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error {
    NSLog(@"Error %@", error.localizedDescription);
}

- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    [self performSegueWithIdentifier:@"chooseProject" sender:dataContainer];
}


@end
