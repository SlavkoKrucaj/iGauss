//
//  ViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "GaussViewController.h"
#import "SKBindingManager.h"
#import "LoginParams.h"
#import "CustomAlertView.h"
#import "Sources.h"
#import "LoginModel.h"
#import "ProjectSessionParams.h"
#import "UIImageView+GaussAnimated.h"
#import "CustomAlertView.h"

@interface GaussViewController ()
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
@end

@implementation GaussViewController

#pragma mark - view initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:GaussAuthToken]) {
        [self performSegueWithIdentifier:@"openProjectSessions" sender:self];
    } else {
    
        self.bindingManager = [[SKBindingManager alloc] init];
        self.loginParams = [[LoginParams alloc] init];
        
        [self bind];
    }
    
//    self.loginParams.username = @"slavko@infinum.hr";
//    self.loginParams.password = @"slavko";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.userNameTextField.font = [UIFont fontWithName:@"GothamMediumHR" size:16];
    self.passwordTextField.font = [UIFont fontWithName:@"GothamMediumHR" size:16];
    
    if (!self.bindingManager) {
        self.bindingManager = [[SKBindingManager alloc] init];
        self.loginParams = [[LoginParams alloc] init];
        
        [self bind];
    }
    
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

#pragma mark - Binding

- (void)bind {

    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"loginBindingUsername"   forKey:BindingId];
    [bindingOptions setObject:self.userNameTextField    forKey:BindingFrom];
    [bindingOptions setObject:BindingPropertyTextField  forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.loginParams          forKey:BindingTo];
    [bindingOptions setObject:@"username"               forKey:BindingToKeyPath];
    [bindingOptions setObject:@YES                      forKey:BindingTwoWayBinding];
    [bindingOptions setObject:BindingInitialValueTo     forKey:BindingInitialValueTo];
    
    [self.bindingManager bind:bindingOptions];
    
    bindingOptions = [NSMutableDictionary dictionary];
    
    [bindingOptions setObject:@"loginBindingPassword"   forKey:BindingId];
    [bindingOptions setObject:self.passwordTextField    forKey:BindingFrom];
    [bindingOptions setObject:BindingPropertyTextField  forKey:BindingFromKeyPath];
    [bindingOptions setObject:self.loginParams          forKey:BindingTo];
    [bindingOptions setObject:@"password"               forKey:BindingToKeyPath];
    [bindingOptions setObject:@YES                      forKey:BindingTwoWayBinding];
    [bindingOptions setObject:BindingInitialValueTo     forKey:BindingInitialValueTo];
    
    [self.bindingManager bind:bindingOptions];
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

        [UIView animateWithDuration:duration/2 animations:^{

            self.gaussLogo.alpha = 1.;

        }];
        
    }];
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.userNameTextField]) {
      
        [self.passwordTextField becomeFirstResponder];
    
    } else {
    
        [self.passwordTextField resignFirstResponder];
        self.view.userInteractionEnabled = NO;
        
        [self login];
    
    }
    return NO;
}

#pragma mark - Login button action

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
    NSLog(@"Username: %@, Password: %@", self.loginParams.username, self.loginParams.password);
    
    if (self.userNameTextField.isFirstResponder)
        [self.userNameTextField resignFirstResponder];
    
    else if (self.passwordTextField.isFirstResponder)
        [self.passwordTextField resignFirstResponder];
    
    if (self.loginParams.username.length == 0 || self.loginParams.password.length == 0) {
        CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Error" subtitle:@"Molimo popunite oba polja." discard:@"" confirm:@"Ok"];
        [alertView show];
        return;
    }

    [self.gaussLogo animateLogo];
    self.view.userInteractionEnabled = NO;
    
    [self login];

}

#pragma mark - Login action

- (void)login {
    
    Source *projectsSource = [Sources createProjectsSource];
    projectsSource.delegate = self;

    self.loginSource = [Sources createLoginSource];
    self.loginSource.params = self.loginParams;
    self.loginSource.delegate = self;
    self.loginSource.nextSource = projectsSource;
    [self.loginSource loadAsync];
    
    
}

#pragma mark - Source delegate

- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    
    self.view.userInteractionEnabled = YES;
    [self.gaussLogo stopAnimatingLogo];
    
    [self performSegueWithIdentifier:@"openProjectSessions" sender:self];

}

- (void)intermediateSource:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    LoginModel *model = (LoginModel *)dataContainer;
    [[NSUserDefaults standardUserDefaults] setObject:model.token forKey:GaussAuthToken];
    
    ProjectSessionParams *params = [[ProjectSessionParams alloc] init];
    params.authToken = model.token;
    
    source.nextSource.params = params;
}

- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error {
    [self.gaussLogo stopAnimatingLogo];
    self.view.userInteractionEnabled = YES;
    
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Error" subtitle:error.localizedDescription discard:@"" confirm:@"Ok"];
    [alertView show];
    
}

@end
