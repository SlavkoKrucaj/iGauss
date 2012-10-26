//
//  CustomAlertView.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "CustomAlertView.h"

#define ANIMATION_DURATION 0.3

@implementation CustomAlertView

+ (CustomAlertView *)createInView:(UIView *)owner withImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle discard:(NSString *)discard confirm:(NSString *)confirm {

    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CustomAlertView" owner:owner options:nil];
    CustomAlertView *alertView = (CustomAlertView *)[nibs objectAtIndex:0];
    
    alertView.icon.image = [UIImage imageNamed:image];
    alertView.title.text = title;
    alertView.subtitle.text = subtitle;
    [alertView.discardButton setTitle:discard forState:UIControlStateNormal];
    [alertView.confirmButton setTitle:confirm forState:UIControlStateNormal];
    
    alertView.alpha = 0.;
    [owner addSubview:alertView];
    
    return alertView;
}

- (void)show {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.alpha = 1.;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.alpha = 0.;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - actions

- (IBAction)discard:(UIButton *)sender {
    if ([self.discardButton.titleLabel.text isEqualToString:@""]) return;

    if ([self.delegate respondsToSelector:@selector(customAlertViewDiscarded:)]) {

        [self.delegate customAlertViewDiscarded:self];

    } else {
    
        [self dismiss];
    
    }
    
}

- (IBAction)confirm:(UIButton *)sender {
    if ([self.confirmButton.titleLabel.text isEqualToString:@""]) return;
    
    if ([self.delegate respondsToSelector:@selector(customAlertViewConfirmed:)]) {
        
        [self.delegate customAlertViewConfirmed:self];
        
    }
}

@end
