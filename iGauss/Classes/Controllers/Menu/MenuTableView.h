//
//  MenuTableView.h
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableView.h"
#import "Project.h"

@protocol SlideOutMenuDelegate <NSObject>

@required
- (void)menuChangedSelectionTo:(NSString *)selectionName;
- (void)openProjectWithId:(Project *)projectId;

@end

@interface MenuTableView : CoreDataTableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SlideOutMenuDelegate> menuDelegate;

@end
