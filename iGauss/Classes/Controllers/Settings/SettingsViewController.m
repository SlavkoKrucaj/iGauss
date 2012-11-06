//
//  SettingsViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 6.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *notImplementedLabel;

@end

@implementation SettingsViewController

#pragma mark - Gauss naivgation bar setup

- (void)setupGaussNavigationBar:(GaussNavigationBar *)gaussNavigationBar {
    gaussNavigationBar.titleLabel.text = @"Settings";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notImplementedLabel.font = AGORA_FONT(20);
}

- (void)viewDidUnload {
    [self setNotImplementedLabel:nil];
    [super viewDidUnload];
}
@end
