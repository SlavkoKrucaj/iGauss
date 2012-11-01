//
//  GaussNavigationBar.m
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "GaussNavigationBar.h"

@interface GaussNavigationBar()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel  *titleLabel;

@end

@implementation GaussNavigationBar

- (void)createNavigation {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation_bar"]];
    
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 0, 45, 45)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 230, 45)];
    self.titleLabel.font = AGORA_FONT(20);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.leftButton.userInteractionEnabled = NO;
    self.rightButton.userInteractionEnabled = NO;
    
    [self addSubview:backgroundView];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self addSubview:self.titleLabel];
}

- (id)init {
    self = [super init];
    if (self) {
        [self createNavigation];
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNavigation];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createNavigation];
    }
    return self;

}

#pragma mark - public actions

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setLeftButtonImage:(NSString *)image {
    [self.leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setRightButtonImage:(NSString *)image {
    [self.rightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)setLeftButtonTarget:(id)target action:(SEL)action {
    self.leftButton.userInteractionEnabled = YES;
    [self.leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRightButtonTarget:(id)target action:(SEL)action {
    self.rightButton.userInteractionEnabled = YES;
    [self.rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
