//
//  ProjectSessionsViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableView.h"
#import "CustomAlertView.h"
#import "Source.h"
#import "ProjectSessionCell.h"

@interface ProjectSessionsViewController : UIViewController <CustomAlertViewDelegate, SourceDelegate, UITableViewDataSource, UITableViewDelegate, ProjectSessionCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *screenTitle;

@end
