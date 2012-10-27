//
//  ViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ViewController.h"
#import "SKBindingManager.h"
#import "LoginParams.h"
#import "CustomAlertView.h"
#import "Sources.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gaussLogo;
@property (weak, nonatomic) IBOutlet UIImageView *gaussTitle;
@property (weak, nonatomic) IBOutlet UIImageView *gaussSubtitle;

@property (weak, nonatomic) IBOutlet UIImageView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) SKBindingManager *bindingManager;
@property (nonatomic, strong) LoginParams *loginParams;

@property (nonatomic, strong) Source *loginSource;
@property (nonatomic, strong) Source *workingHoursSource;
@end

@implementation ViewController

#pragma mark - view initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bindingManager = [[SKBindingManager alloc] init];
    self.loginParams = [[LoginParams alloc] init];
    
    //create binding options dictionary which contains all properties needed for binding
    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"loginBindingUsername" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.userNameTextField forKey:BindingFrom];
    [bindingOptions setObject:BindingPropertyTextField forKey:BindingFromKeyPath];

    //set object and propety - from
    [bindingOptions setObject:self.loginParams forKey:BindingTo];
    [bindingOptions setObject:@"username" forKey:BindingToKeyPath];

    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:NO] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];
    
    bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"loginBindingPassword" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.passwordTextField forKey:BindingFrom];
    [bindingOptions setObject:BindingPropertyTextField forKey:BindingFromKeyPath];
    
    //set object and propety - from
    [bindingOptions setObject:self.loginParams forKey:BindingTo];
    [bindingOptions setObject:@"password" forKey:BindingToKeyPath];
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:NO] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //register for notifications from UIKeyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [self.bindingManager activateAllBindings];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //remove observers from UIKeyboard
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [self.bindingManager deactivateAllBindings];
}

#pragma mark - Keyboard opening and closing handling (animations)

- (void)keyboardWillShow:(NSNotification *)notification {

    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat deltaY = CGRectGetMinY(self.gaussTitle.frame) - 20;

    //we should animate ui
    [UIView animateWithDuration:duration animations:^{
        
        self.gaussLogo.alpha = 0.;
        self.gaussTitle.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        self.gaussSubtitle.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        
        self.textFieldContainer.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        self.userNameTextField.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, -deltaY);
        
        self.loginButton.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //we should animate ui
    [UIView animateWithDuration:duration animations:^{
        
        self.gaussTitle.transform = CGAffineTransformIdentity;
        self.gaussSubtitle.transform = CGAffineTransformIdentity;
        
        self.textFieldContainer.transform = CGAffineTransformIdentity;
        self.userNameTextField.transform = CGAffineTransformIdentity;
        self.passwordTextField.transform = CGAffineTransformIdentity;
        
        self.loginButton.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration animations:^{

            self.gaussLogo.alpha = 1.;

        }];
        
        //keyboard will resign only when we try to login
        [self login];
        
    }];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.userNameTextField]) {
      
        [self.passwordTextField becomeFirstResponder];
    
    } else {
    
        [self.passwordTextField resignFirstResponder];
        self.view.userInteractionEnabled = NO;
    
    }
    return NO;
}

#pragma mark - Login button action

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    if (self.userNameTextField.isFirstResponder)
        [self.userNameTextField resignFirstResponder];
    
    else if (self.passwordTextField.isFirstResponder)
        [self.passwordTextField resignFirstResponder];
    
    else {
        self.view.userInteractionEnabled = NO;
        [self login];
        return;
    }

    self.view.userInteractionEnabled = NO;
}

#pragma mark - Login action

- (void)login {
    
    NSLog(@"Username: %@ & password: %@", self.loginParams.username, self.loginParams.password);
    self.loginSource = [Sources createLoginSource];
    self.loginSource.params = self.loginParams;
    self.loginSource.delegate = self;
    [self.loginSource loadAsync];
    
}

#pragma mark - Source delegate

- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    if ([source isEqual:self.loginSource]) {

        self.workingHoursSource = [Sources createWorkingHoursSource];
        self.workingHoursSource.delegate = self;
        [self.workingHoursSource loadAsync];
        
    } else if ([source isEqual:self.workingHoursSource]) {
        self.view.userInteractionEnabled = YES;
        [self performSegueWithIdentifier:@"loginSeque" sender:self];
    }
}

- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error {
    self.view.userInteractionEnabled = YES;
    NSLog(@"Error %@", error.localizedDescription);
}

@end
