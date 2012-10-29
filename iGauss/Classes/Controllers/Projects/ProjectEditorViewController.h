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

@interface ProjectEditorViewController : UIViewController <CustomAlertViewDelegate, CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

@property (nonatomic, strong) ProjectSession *projectSession;

@end
