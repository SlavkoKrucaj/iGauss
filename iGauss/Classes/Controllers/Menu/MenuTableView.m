//
//  MenuTableView.m
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "MenuTableView.h"
#import "UIColor+Create.h"
#import "MenuCell.h"
#import "UIImageView+AFNetworking.h"

@interface MenuItem : NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) UIImage *itemImageNormal;
@property (nonatomic, strong) UIImage *itemImagePressed;
@end

@implementation MenuItem
@end

@interface MenuTableView()
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation MenuTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
        [self initializeData];
    }
    return self;
}

- (void)initializeUI {
    self.backgroundColor = [UIColor withRed:40 green:40 blue:40 alpha:1.0];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 58)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    NSURL *avatarUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:GaussAvatar]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width, 58)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = GOTHAM_FONT(20);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [[NSUserDefaults standardUserDefaults] objectForKey:GaussUsername];;
    
    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, 56, label.frame.size.width, 1)];
    black.backgroundColor = [UIColor blackColor];
    
    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 57, label.frame.size.width, 1)];
    gray.backgroundColor = [UIColor withRed:51 green:51 blue:51 alpha:1.0];
    
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    
    [headerView addSubview:black];
    [headerView addSubview:gray];
    self.tableHeaderView = headerView;
    
}

- (void)initializeData {
    
    self.data = [NSMutableArray array];
    
    MenuItem *item = [[MenuItem alloc] init];
    item.itemName = @"TIMETRACKING";
    item.itemImageNormal = [UIImage imageNamed:@"timetracking_icon_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"timetracking_icon_pressed"];
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"TICKETS";
    item.itemImageNormal = [UIImage imageNamed:@"tickets_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"tickets_pressed"];
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"SETTINGS";
    item.itemImageNormal = [UIImage imageNamed:@"settings_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"settings_pressed"];
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"LOGOUT";
    item.itemImageNormal = [UIImage imageNamed:@"logout_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"logout_pressed"];
    
    [self.data addObject:item];
}

#pragma mark delegates and data sources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"MenuCell";
    
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
        cell.itemName.font = GOTHAM_FONT(17);
        cell.itemName.shadowColor = [UIColor blackColor];
        cell.itemName.shadowOffset = CGSizeMake(0,1);

        UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
        myBackView.backgroundColor = [UIColor withRed:51 green:51 blue:51 alpha:1];
        cell.selectedBackgroundView = myBackView;

    }
    
    MenuItem *item = [self.data objectAtIndex:indexPath.row];

    cell.imageView.image = item.itemImageNormal;
    cell.imageView.highlightedImage = item.itemImagePressed;
    
    cell.itemName.text = item.itemName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [self.data objectAtIndex:indexPath.row];
    [self.menuDelegate menuChangedSelectionTo:[item.itemName lowercaseString]];
}
@end
