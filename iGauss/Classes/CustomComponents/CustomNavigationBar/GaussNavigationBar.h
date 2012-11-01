//
//  GaussNavigationBar.h
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaussNavigationBar : UIView

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel  *titleLabel;

- (void)setTitle:(NSString *)title;
- (void)setLeftButtonImage:(NSString *)image;
- (void)setRightButtonImage:(NSString *)image;

- (void)setLeftButtonTarget:(id)target action:(SEL)action;
- (void)setRightButtonTarget:(id)target action:(SEL)action;

@end
