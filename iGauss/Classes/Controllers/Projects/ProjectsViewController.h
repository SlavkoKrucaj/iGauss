//
//  ProjectViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableView.h"
#import "ODRefreshControl.h"
#import "Source.h"

@interface ProjectsViewController : UIViewController <SourceDelegate, UITableViewDelegate, UITableViewDataSource>

@end
