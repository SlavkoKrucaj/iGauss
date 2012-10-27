//
//  WorkViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
#import "CKCalendarView.h"
#import "Source.h"

@interface WorkViewController : UIViewController <CustomAlertViewDelegate, CKCalendarDelegate, SourceDelegate>

@end
