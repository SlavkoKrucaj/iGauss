//
//  MenuTableView.h
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideOutMenuDelegate <NSObject>

@required
- (void)menuChangedSelectionTo:(NSString *)selectionName;

@end

@interface MenuTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SlideOutMenuDelegate> menuDelegate;

@end
