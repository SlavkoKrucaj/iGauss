//
//  ProjectsViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Work.h"
#import "Store.h"

@interface ProjectsViewController : UITableViewController

@property (nonatomic, strong) Work *model;
@property (nonatomic, strong) Store *projects;

@end
