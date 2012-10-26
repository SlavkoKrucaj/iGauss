//
//  WorkingHoursController.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "WorkingHoursController.h"

@interface WorkingHoursController ()

@end

@implementation WorkingHoursController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - navigation actions

- (IBAction)logout:(UIButton *)sender {
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"logout_button" title:@"Log out?" subtitle:@"Are you sure you want to log out?" discard:@"No" confirm:@"Log out"];
    
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)addWork:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"createWork" sender:nil];
    
}

#pragma mark - custom alert delegate

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    
    [self.navigationController popViewControllerAnimated:YES];
    [alertView dismiss];
}
@end
