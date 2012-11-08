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
#import "App.h"
#import "DocumentHandler.h"
#import "ProjectSessionParams.h"
#import "Sources.h"
#import "UIColor+Create.h"
#import "MenuProjectCell.h"
#import "Project.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

@interface MenuItem : NSObject
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) UIImage *itemImageNormal;
@property (nonatomic, strong) UIImage *itemImagePressed;
@property (nonatomic, strong) NSString *controllerRestorationId;
@end

@implementation MenuItem
@end

@interface MenuTableView()
@property (nonatomic, strong) Source *projectsSource;
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
    
    [self setupSearchBar];
    
}

- (void)initializeData {
    
    self.data = [NSMutableArray array];
    
    MenuItem *item = [[MenuItem alloc] init];
    item.itemName = @"TIMETRACKING";
    item.itemImageNormal = [UIImage imageNamed:@"timetracking_icon_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"timetracking_icon_pressed"];
    item.controllerRestorationId = @"ProjectSessionsViewController";
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"TICKETS";
    item.itemImageNormal = [UIImage imageNamed:@"tickets_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"tickets_pressed"];
    item.controllerRestorationId = @"MyTicketsViewController";
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"SETTINGS";
    item.itemImageNormal = [UIImage imageNamed:@"settings_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"settings_pressed"];
    item.controllerRestorationId = @"SettingsViewController";
    [self.data addObject:item];
    
    item = [[MenuItem alloc] init];
    item.itemName = @"LOGOUT";
    item.itemImageNormal = [UIImage imageNamed:@"logout_normal"];
    item.itemImagePressed = [UIImage imageNamed:@"logout_pressed"];
    item.controllerRestorationId = @"Logout";
    [self.data addObject:item];
    
        
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"projectId" ascending:YES]];
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:document.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];

    }];
}

#pragma mark - Search bar

- (void)setupSearchBar {
    
//    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_bar"]];
//    backgroundImageView.userInteractionEnabled = YES;
//    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(44, 13, 250, 25)];
//    searchField.font = AGORA_FONT(16);
//    searchField.textColor = [UIColor whiteColor];
//    [backgroundImageView addSubview:searchField];
//    
//    self.tableHeaderView = backgroundImageView;
    
}

#pragma mark - first section header view creation

- (UIView *)headerForFirstSection {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 58)];
    headerView.backgroundColor = [UIColor withRed:40 green:40 blue:40 alpha:1.0];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 40, 40)];
    NSURL *avatarUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:GaussAvatar]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"avatar-placeholder"]];
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.masksToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width, 58)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = GOTHAM_FONT(20);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [[NSUserDefaults standardUserDefaults] objectForKey:GaussUsername];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    
    UIView *black = [[UIView alloc] initWithFrame:CGRectMake(0, 56, label.frame.size.width, 1)];
    black.backgroundColor = [UIColor blackColor];
    
    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 57, label.frame.size.width, 1)];
    gray.backgroundColor = [UIColor withRed:51 green:51 blue:51 alpha:1.0];
    
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    
    [headerView addSubview:black];
    [headerView addSubview:gray];
    
    return headerView;
}

#pragma mark delegates and data sources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0)? [self.data count]:[[self.fetchedResultsController.sections objectAtIndex:0] numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0)? 50:40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0)? 58:25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return [self headerForFirstSection];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 25)];
    header.backgroundColor = [UIColor withRed:51 green:51 blue:51 alpha:1];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, self.frame.size.width - 50, 25)];
    headerLabel.text = @"My projects";
    headerLabel.font = AGORA_FONT(15);
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    
    [header addSubview:headerLabel];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
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
        cell.separator.hidden = (indexPath.row == self.data.count -1);
        
        cell.itemName.text = item.itemName;
        
        return cell;
    } else {
        NSString *reuseIdentifier = @"MenuProjectCell";
        MenuProjectCell *cell = (MenuProjectCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
            cell.projectName.font = GOTHAM_FONT(15);
            cell.projectName.shadowColor = [UIColor blackColor];
            cell.projectName.shadowOffset = CGSizeMake(0,1);
            
            UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
            myBackView.backgroundColor = [UIColor withRed:51 green:51 blue:51 alpha:1];
            cell.selectedBackgroundView = myBackView;
            
        }
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        Project *project = [((CoreDataTableView *)tableView).fetchedResultsController objectAtIndexPath:newIndexPath];
        cell.projectName.text = project.projectName;
        return cell;
    }
}

#pragma mark - fetched results controller

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    sectionIndex--;
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


#pragma mark - cell selection

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MenuItem *item = [self.data objectAtIndex:indexPath.row];
        [self.menuDelegate menuChangedSelectionTo:item.controllerRestorationId];
    } else {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
        Project *project = (Project *)[self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.menuDelegate openProjectWithId:project];
    }
}
@end
