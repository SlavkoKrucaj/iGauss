//
//  MenuContainerControllerViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 6.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableView.h"
#import "CustomAlertView.h"

@interface MenuContainerController : UIViewController <SlideOutMenuDelegate, CustomAlertViewDelegate>

- (void)setContentViewController:(UIViewController *)viewController;

@end
