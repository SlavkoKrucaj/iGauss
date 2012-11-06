//
//  MenuContainerControllerViewController.m
//  iGauss
//
//  Created by Slavko Krucaj on 6.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "MenuContainerController.h"
#import "PaperFoldView.h"
#import "MenuTableView.h"
#import "UIView+Frame.h"
#import "UIView+Shadow.h"
#import "GaussNavigationBar.h"
#import "GaussNavigationCreationProtocol.h"

#define CHANGE_VIEW_ANIMATION_DURATION 0.2

@interface MenuContainerController ()
@property (nonatomic, strong) PaperFoldView *foldContainer;

@property (nonatomic, weak) IBOutlet GaussNavigationBar *navigation;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSString *currentChildViewControllerIdentifier;
@end

@implementation MenuContainerController

#pragma mark view loading

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMenu];
    
    MenuTableView *menuView = [[MenuTableView alloc] initWithFrame:CGRectMake(0, 0, 258, 460)];
    [menuView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    menuView.menuDelegate = self;
    
    [self.view addShadow];
    [self.view setY:0];

    self.foldContainer = [[PaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 460)];
    [self.foldContainer setLeftFoldContentView:menuView];
    [self.foldContainer setCenterContentView:self.view];
    
    self.contentView.backgroundColor = [UIColor blackColor];

    [self setInitialContentViewController];
    
    // Add the PaperFold as main view
    self.view = self.foldContainer;


}

#pragma mark - Initial setting up

- (void)setupMenu {
    
    self.navigation.titleLabel.text = @"";
    [self.navigation setLeftButtonImage:@"menu_button"];
    [self.navigation setLeftButtonTarget:self action:@selector(openMenu:)];
    
    [self.navigation setRightButtonImage:@""];
    [self.navigation setRightButtonTarget:nil action:nil];
    
}

- (void)setInitialContentViewController {
    
    self.currentChildViewControllerIdentifier = @"ProjectSessionsViewController";
    UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:self.currentChildViewControllerIdentifier];

    if ([initial conformsToProtocol:@protocol(GaussNavigationCreationDelegate) ]) {
        [initial performSelector:@selector(setupGaussNavigationBar:) withObject:self.navigation];
    } else {
        [self setupMenu];
    }
    
    initial.view.frame = self.contentView.bounds;
    [self.contentView addSubview:initial.view];
    
    [self addChildViewController:initial];
    [initial didMoveToParentViewController:self];
    
}

#pragma mark - navigation handling

- (void)openMenu:(UIButton *)sender {
    if (self.foldContainer.state == PaperFoldStateLeftUnfolded) {
        [self.foldContainer setPaperFoldState:PaperFoldStateDefault];
    } else {
        [self.foldContainer setPaperFoldState:PaperFoldStateLeftUnfolded];
    }
}

#pragma mark - menu delegate

- (void)menuChangedSelectionTo:(NSString *)selectionName {
    
    if ([selectionName isEqualToString:@"Logout"]) {
        [self.foldContainer setPaperFoldState:PaperFoldStateDefault];
        [self logout];
        return;
    }

    NSAssert(self.childViewControllers.count == 1, @"There should only be one child controller at time");
    
    if (![self.currentChildViewControllerIdentifier isEqualToString:selectionName]) {

        self.currentChildViewControllerIdentifier = selectionName;
        UIViewController *initial = [self.storyboard instantiateViewControllerWithIdentifier:selectionName];
        [self setContentViewController:initial];
    
    }
}

#pragma mark - logout logic

- (void)logout {
    CustomAlertView *alertView = [CustomAlertView createInView:self.view withImage:@"logout_button" title:@"Log out?" subtitle:@"Are you sure you want to log out?" discard:@"No" confirm:@"Log out"];
    
    alertView.delegate = self;
    [alertView show];
}

- (void)customAlertViewConfirmed:(CustomAlertView *)alertView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - child controller handling

- (void)setContentViewController:(UIViewController *)newViewController {
    
    UIViewController *oldViewController = (self.childViewControllers.count != 0)? [self.childViewControllers objectAtIndex:0]:nil;
    
    [self addChildViewController:newViewController];
    
    if ([newViewController conformsToProtocol:@protocol(GaussNavigationCreationDelegate) ]) {
        [newViewController performSelector:@selector(setupGaussNavigationBar:) withObject:self.navigation];
    } else {
        [self setupMenu];
    }
    
    UIView *oldView = (self.contentView.subviews.count != 0)? [self.contentView.subviews objectAtIndex:0]:nil;
    
    UIView *newView = newViewController.view;
    newView.frame = oldView.frame;
    newView.alpha = 0;
    
    [oldViewController willMoveToParentViewController:nil];
	[self addChildViewController:newViewController];

    [self transitionFromViewController:oldViewController
                      toViewController:newViewController
                              duration:0.2
                               options:UIViewAnimationCurveEaseInOut
                            animations:^{
                                newView.alpha = 1.;
                                oldView.alpha = 0.;
                            }
                            completion:^(BOOL finished){
                                [oldView removeFromSuperview];
                                [newViewController didMoveToParentViewController:self];
                                [oldViewController removeFromParentViewController];
                                
                                [self.foldContainer setPaperFoldState:PaperFoldStateDefault];
                            }
     ];
}


@end
