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
    
    [self setupFoldView];
    
    [self.navigation setTitle:@"Gauss"];
    [self.navigation setLeftButtonImage:@"menu_button"];
    [self.navigation setLeftButtonTarget:self action:@selector(openMenu:)];

    [self.navigation setRightButtonImage:@"add_work_button"];
    [self.navigation setRightButtonTarget:self action:@selector(addNewProjectSession:)];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self setupFetchedResultsController];
}

#pragma mark - Setuping fold view 

- (void)setupFoldView {

    self.foldContainer = [[PaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460)];

    MenuTableView *menuView = [[MenuTableView alloc] initWithFrame:CGRectMake(0, 0, 258, 460)];
    [menuView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    menuView.menuDelegate = self;
    
    [self.view addShadow];
    [self.view setY:0];
    
    [self.foldContainer setLeftFoldContentView:menuView];
    [self.foldContainer setCenterContentView:self.view];
    
    // Add the PaperFold as subview
    self.view = self.foldContainer;

}

#pragma mark - Button actions

- (IBAction)openMenu:(UIButton *)sender {

    if (self.foldContainer.state == PaperFoldStateLeftUnfolded) {
        [self.foldContainer setPaperFoldState:PaperFoldStateDefault];
    } else {
        [self.foldContainer setPaperFoldState:PaperFoldStateLeftUnfolded];
    }

}

- (void)logout {
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"logout_button" title:@"Log out?" subtitle:@"Are you sure you want to log out?" discard:@"No" confirm:@"Log out"];

    alertView.tag = ALERT_LOGOUT;
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)addNewProjectSession:(UIButton *)sender {
    [self performSegueWithIdentifier:@"addNewProjectSession" sender:self];
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
        if (alertView.tag == ALERT_LOGOUT) {
            self.tableView.fetchedResultsController = nil;
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:GaussAuthToken];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:GaussUsername];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
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
        } else if (alertView.tag = ALERT_DELETE) {
            
            [document.managedObjectContext deleteObject:alertView.userDataObject];
            
            [document.managedObjectContext save:nil];
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if (alertView.tag == ALERT_LOGOUT) {
                [self.navigationController popViewControllerAnimated:YES];
            }
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

#pragma mark - Menu delegate

- (void)menuChangedSelectionTo:(NSString *)selectionName {
    if ([selectionName isEqualToString:@"logout"]) {
        [self.foldContainer setPaperFoldState:PaperFoldStateDefault];
        [self logout];
    } else {
        CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"cancel_button" title:@"Not implemented!" subtitle:@"Action is not yet implemented." discard:@"" confirm:@"Ok"];        
        [alertView show];
    }
}
@end
