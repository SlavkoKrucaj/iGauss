//
//  ProjectEditorViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 29.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectSession.h"
#import "CustomAlertView.h"
#import "CKCalendarView.h"
#import "SKBindingManager.h"
#import "GaussNavigationBar.h"

@interface ProjectEditorViewController : UIViewController <CustomAlertViewDelegate, CKCalendarDelegate, SKBindingProtocol, UITextFieldDelegate>


@property (nonatomic, weak) IBOutlet GaussNavigationBar *navigation;

@property (nonatomic, strong) id projectSession;

@end
