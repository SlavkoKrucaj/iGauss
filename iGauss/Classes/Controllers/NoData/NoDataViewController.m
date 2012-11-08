//
//  NoDataViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 8.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "NoDataViewController.h"

@interface NoDataViewController ()
@property (nonatomic, strong) NSString *noDataDescription;
@property (nonatomic, weak) IBOutlet UILabel *noDataLabel;
@end

@implementation NoDataViewController

+ (NoDataViewController *)noDataWithDescription:(NSString *)description {
    NoDataViewController *ndvc = [[NoDataViewController alloc] init];
    ndvc.noDataDescription = description;
    return ndvc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.noDataLabel.font = AGORA_FONT(20);
    self.noDataLabel.text = self.noDataDescription;
}

#pragma mark - Navigation bar

- (void)setupGaussNavigationBar:(GaussNavigationBar *)gaussNavigationBar {
    gaussNavigationBar.titleLabel.text = @"No data";
}
@end
