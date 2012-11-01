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

@interface ProjectEditorViewController : UIViewController <CustomAlertViewDelegate, CKCalendarDelegate, SKBindingProtocol>

@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

@property (nonatomic, strong) id projectSession;

@end
