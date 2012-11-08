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
#import "ProjectEditorViewController.h"
#import "PaperFoldView.h"
#import "UIView+Shadow.h"
#import "MenuTableView.h"
#import "BillingPoint.h"
#import "App.h"

#define ALERT_LOGOUT 11
#define ALERT_DELETE 12

@interface ProjectSessionsViewController ()

@property (nonatomic, strong) Source *projectSessionsSource;
@property (nonatomic, strong) PaperFoldView *foldContainer;

@property (weak, nonatomic) IBOutlet CoreDataTableView *tableView;
@property (weak, nonatomic) ODRefreshControl *refreshControl;

@end

@implementation ProjectSessionsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self setupFetchedResultsController];
}

- (IBAction)addNewProjectSession:(UIButton *)sender {
    [self performSegueWithIdentifier:@"addNewProjectSession" sender:self];
}

#pragma mark - Fetched results controller

- (void)setupFetchedResultsController {
    
    if (!self.fetchRequest) {
        self.fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ProjectSession"];
        self.fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:NO]];
    }
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        self.tableView.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
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
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    
    NSDate *date = [dateFormatter dateFromString:dateString];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    headerView.backgroundColor = [UIColor colorWithRed:178/255. green:89/255. blue:0. alpha:1.];
    
    dateFormatter.dateFormat = @"EEEE";
    NSString *dayName = [dateFormatter stringFromDate:date];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy.";
    dateString = [dateFormatter stringFromDate:date];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 140, 30)];
    dayLabel.text = dayName;
    dayLabel.font = GOTHAM_FONT(15);
    dayLabel.textAlignment = NSTextAlignmentLeft;
    dayLabel.textColor = [UIColor whiteColor];
    dayLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 140, 30)];
    dateLabel.text = dateString;
    dateLabel.font = GOTHAM_FONT(15);
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

    if (indexPath.row + 1 == [[[((CoreDataTableView *)tableView).fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects] ) {
        return session.contentHeight.floatValue;
    }
    
    return session.contentHeight.floatValue - CELL_MARGIN;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ProjectSessionCell";
    
    ProjectSessionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    ProjectSession *session = [((CoreDataTableView *)tableView).fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell setupCell:session];
    cell.delegate = self;
    
    
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
        if (alertView.tag = ALERT_DELETE) {
            
            [document.managedObjectContext deleteObject:alertView.userDataObject];
            
            [document.managedObjectContext save:nil];
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
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

#pragma mark - Project session cell delegate

- (void)cellWithModelWillEdit:(ProjectSession *)session {
    [self performSegueWithIdentifier:@"editProject" sender:session];
}

- (void)cellWithModelWillDelete:(ProjectSession *)session {
    
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"delete_image" title:@"Delete session?" subtitle:@"Are you sure you want to delete session?" discard:@"No" confirm:@"Delete"];
    alertView.delegate = self;
    alertView.tag = ALERT_DELETE;
    alertView.userDataObject = session;
    
    [alertView show];
}

#pragma mark - Segue preparation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editProject"]) {
        [(ProjectEditorViewController *)segue.destinationViewController setProjectSession:sender];
    }
}

#pragma mark - navigation bar setup

- (void)setupGaussNavigationBar:(GaussNavigationBar *)gaussNavigationBar {
    if (self.project) {
        gaussNavigationBar.titleLabel.text = self.project.projectName;
    } else {
        gaussNavigationBar.titleLabel.text = @"Timetracking";
        [gaussNavigationBar setRightButtonImage:@"add_work_button"];
        [gaussNavigationBar setRightButtonTarget:self action:@selector(addNewProjectSession:)];
    }
}

@end
