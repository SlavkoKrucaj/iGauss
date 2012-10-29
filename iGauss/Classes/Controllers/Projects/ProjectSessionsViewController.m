//
//  ProjectSessionsViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSessionsViewController.h"
#import "ODRefreshControl.h"
#import "Source.h"
#import "Sources.h"
#import "DocumentHandler.h"
#import "ProjectSessionParams.h"
#import "ProjectSession.h"
#import "CustomAlertView.h"
#import "ProjectSessionCell.h"
#import "ProjectSession+Create.h"
#import "UIView+Frame.h"
#import "Project.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectSessionsViewController ()

@property (nonatomic, strong) Source *projectSessionsSource;

@property (weak, nonatomic) IBOutlet CoreDataTableView *tableView;
@property (weak, nonatomic) ODRefreshControl *refreshControl;

@end

@implementation ProjectSessionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self setupFetchedResultsController];
}

#pragma mark - Button actions

- (IBAction)logout:(UIButton *)sender {
#warning will be come deprecated when menu comes in
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"logout_button" title:@"Log out?" subtitle:@"Are you sure you want to log out?" discard:@"No" confirm:@"Log out"];
    
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)addNewProjectSession:(UIButton *)sender {
    [self performSegueWithIdentifier:@"testProjects" sender:self];
}

#pragma mark - Fetched results controller

- (void)setupFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProjectSession"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:NO]];
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        self.tableView.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                      managedObjectContext:document.managedObjectContext
                                                                                        sectionNameKeyPath:@"sessionDate"
                                                                                                 cacheName:nil];
        
        ProjectSessionParams *params = [[ProjectSessionParams alloc] init];
        params.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:GaussAuthToken];
        
        self.projectSessionsSource = [Sources createProjectSessionsSource];
        self.projectSessionsSource.params = params;
        self.projectSessionsSource.delegate = self;
        [self.projectSessionsSource loadAsync];
    }];
    
}


#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *dateString = [[[((CoreDataTableView *)tableView).fetchedResultsController sections] objectAtIndex:section] name];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    NSDate *date = [dateFormatter dateFromString:dateString];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    headerView.backgroundColor = [UIColor colorWithRed:178/255. green:89/255. blue:0. alpha:1.];
    
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy.";
    dateString = [dateFormatter stringFromDate:date];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 140, 26)];
    dayLabel.text = dayName;
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 140, 26)];
    dateLabel.text = dateString;
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:dayLabel];
    [headerView addSubview:dateLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[((CoreDataTableView *)tableView).fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[((CoreDataTableView *)tableView).fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [((CoreDataTableView *)tableView).fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectSession *session = [((CoreDataTableView *)tableView).fetchedResultsController objectAtIndexPath:indexPath];
    
    return session.cellHeight.floatValue;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ProjectSessionCell";
    
    ProjectSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    ProjectSession *session = [((CoreDataTableView *)tableView).fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.noteText.text = session.sessionNote;
    cell.sessionTitleLabel.text = session.project.projectFullName;
    cell.sessionTimeLabel.text = session.sessionTime.stringValue;
    
    cell.cellBackground.layer.cornerRadius = 5;
    
    //postavi novi frame za title
    [cell.sessionTitleLabel setHeight:session.titleHeight.floatValue];
    
    //postavi novi frame za time
    [cell.sessionTimeLabel setY:CGRectGetMaxY(cell.sessionTitleLabel.frame)];
    [cell.sessionTimeLabel setHeight:session.timeHeight.floatValue];
    
    //postavi novi frame za note
    [cell.noteText setY:CGRectGetMaxY(cell.sessionTimeLabel.frame)];
    [cell.noteText setHeight:session.noteHeight.floatValue];
    
    //postavi novi frame za buttone
    [cell.buttonHolder setY:(CGRectGetMaxY(cell.noteText.frame) + CELL_NOTE_MARGIN)];
    
    //prosiri background
    [cell.cellBackground setHeight:session.cellHeight.floatValue - 2*CELL_MARGIN];
    
    
    return cell;
}

#pragma mark - Refresh delegate

- (void)startRefresh {
    self.projectSessionsSource.delegate = self;
    [self.projectSessionsSource loadAsync];
}

#pragma mark - Custom alert view delegate

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        
        self.tableView.fetchedResultsController = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:GaussAuthToken];
        
        NSFetchRequest *allProjectsFetch = [[NSFetchRequest alloc] initWithEntityName:@"Project"];
        NSArray *allProjects = [document.managedObjectContext executeFetchRequest:allProjectsFetch error:nil];

        for (Project *project in allProjects) {
            [document.managedObjectContext deleteObject:project];
        }
        
        NSFetchRequest *allProjectSessionsFetch = [[NSFetchRequest alloc] initWithEntityName:@"ProjectSession"];
        NSArray *allSessions = [document.managedObjectContext executeFetchRequest:allProjectSessionsFetch error:nil];

        for (ProjectSession *session in allSessions) {
            [document.managedObjectContext deleteObject:session];
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - Source delegate

- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error {
    [self.refreshControl endRefreshing];
}

- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    [self.refreshControl endRefreshing];
}
@end
