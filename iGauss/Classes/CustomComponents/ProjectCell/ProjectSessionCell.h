//
//  ProjectSessionCell.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectSession.h"

@protocol ProjectSessionCellDelegate <NSObject>

@required
- (void)cellWithModelWillEdit:(ProjectSession *)session;
- (void)cellWithModelWillDelete:(ProjectSession *)session;
@end

@interface ProjectSessionCell : UITableViewCell

@property (weak, nonatomic) ProjectSession *session;
@property (weak, nonatomic) id<ProjectSessionCellDelegate> delegate;

- (void)setupCell:(ProjectSession *)session;



@end
