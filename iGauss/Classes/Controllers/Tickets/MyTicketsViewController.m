//
//  MyTicketsViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 6.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "MyTicketsViewController.h"

@interface MyTicketsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *notImplementedLabel;
@end

@implementation MyTicketsViewController

#pragma mark - Gauss navigation bar setup

- (void)setupGaussNavigationBar:(GaussNavigationBar *)gaussNavigationBar {
    gaussNavigationBar.titleLabel.text = @"My tickets";
    
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
