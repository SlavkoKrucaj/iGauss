//
//  ProjectsViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectsViewController.h"
#import "ProjectCell.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectCell";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.projectId = 1;
    cell.projectName.text = (NSString *)[[[self.projects items] objectAtIndex:indexPath.row] projectName];
    cell.disclousureImageView.image = [UIImage imageNamed:@"disclousure_button_pressed"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.model.project = ((ProjectCell *)[tableView cellForRowAtIndexPath:indexPath]).projectName.text;
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
