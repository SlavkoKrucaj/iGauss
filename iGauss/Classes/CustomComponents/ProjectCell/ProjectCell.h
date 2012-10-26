//
//  ProjectCell.h
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectCell : UITableViewCell

@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, weak) IBOutlet UILabel *projectName;
@property (nonatomic, weak) IBOutlet UIImageView *disclousureImageView;

@end
