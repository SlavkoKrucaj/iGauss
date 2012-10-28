//
//  ProjectSessionCell.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSessionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noteText;
@property (weak, nonatomic) IBOutlet UIView *buttonHolder;
@property (weak, nonatomic) IBOutlet UIView *cellBackground;

@end
