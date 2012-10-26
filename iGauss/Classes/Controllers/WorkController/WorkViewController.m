//
//  WorkViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "WorkViewController.h"
#import "SKBindingManager.h"
#import "ProjectModel.h"
#import "ProjectsViewController.h"

@interface WorkViewController ()
@property (nonatomic, strong) SKBindingManager *bindingManager;
@property (nonatomic, strong) ProjectModel *projectModel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@end

@implementation WorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bindingManager = [[SKBindingManager alloc] init];
    self.projectModel = [[ProjectModel alloc] init];
    
    //create binding options dictionary which contains all properties needed for binding
    NSMutableDictionary *bindingOptions = [NSMutableDictionary dictionary];
    
	//set binding id for this connection
    [bindingOptions setObject:@"projectNameBinding" forKey:BindingId];
    
    //set object and property - to
    [bindingOptions setObject:self.projectModel forKey:BindingFrom];
    [bindingOptions setObject:@"projectName" forKey:BindingFromKeyPath];
    
    //set object and propety - from
    [bindingOptions setObject:self.projectNameLabel forKey:BindingTo];
    [bindingOptions setObject:BindingPropertyLabel forKey:BindingToKeyPath];
    
    //specify if you want two-way or one-way binding
    [bindingOptions setObject:[NSNumber numberWithBool:NO] forKey:BindingTwoWayBinding];
    
    //add binding
    [self.bindingManager bind:bindingOptions];
    
    self.projectModel.projectName = @"Choose project";
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
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"accept_button" title:@"Save" subtitle:@"Your changes have been succesfully saved" discard:@"" confirm:@"Ok"];
    
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - Alert delegates

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:YES];
    [alertView dismiss];
}

#pragma mark Work actions

- (IBAction)chooseProject:(UIButton *)sender {
    [self performSegueWithIdentifier:@"chooseProject" sender:nil];
}

- (IBAction)chooseDate:(UIButton *)sender {
}

#pragma mark - prepare for Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"chooseProject"]) {
        [segue.destinationViewController setModel:self.projectModel];
    }
}
@end
