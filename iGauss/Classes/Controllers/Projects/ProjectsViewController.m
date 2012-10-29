//
//  ProjectViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectsViewController.h"
#import "Sources.h"
#import "Source.h"
#import "DocumentHandler.h"
#import "ProjectSessionParams.h"
#import "Project.h"
#import "ProjectCell.h"

@interface ProjectsViewController ()

@property (nonatomic, strong) Source *projectsSource;

@property (weak, nonatomic) IBOutlet CoreDataTableView *tableView;
@property (weak, nonatomic) ODRefreshControl *refreshControl;

@end

@implementation ProjectsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [self.refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self setupFetchedResultsController];
}

#pragma mark - Button actions

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Fetched results controller

- (void)setupFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"projectId" ascending:YES]];
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        self.tableView.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:document.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
        ProjectSessionParams *params = [[ProjectSessionParams alloc] init];
        params.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:GaussAuthToken];
        
        self.projectsSource = [Sources createProjectsSource];
        [self.projectsSource loadAsync];
    }];

}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[((CoreDataTableView *)tableView).fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[((CoreDataTableView *)tableView).fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[((CoreDataTableView *)tableView).fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [((CoreDataTableView *)tableView).fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [((CoreDataTableView *)tableView).fetchedResultsController sectionIndexTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"ProjectCell";
    
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_normal_background.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_selected_background.png"]];
    
    Project *project = [((CoreDataTableView *)tableView).fetchedResultsController objectAtIndexPath:indexPath];
    cell.projectName.text = project.projectFullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Refreshing

- (void)startRefresh {

    self.projectsSource.delegate = self;
    [self.projectsSource loadAsync];
}

#pragma mark - Source delegate

- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error {
    [self.refreshControl endRefreshing];
}

- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer {
    [self.refreshControl endRefreshing];
}

@end
