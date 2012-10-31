//
//  CustomAlertView.h
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertView;

@protocol CustomAlertViewDelegate <NSObject>
@optional
- (void)customAlertViewConfirmed:(CustomAlertView *)alertView;
- (void)customAlertViewDiscarded:(CustomAlertView *)alertView;
@end

@interface CustomAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UIButton *discardButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) id userDataObject;

@property (weak, nonatomic) id<CustomAlertViewDelegate> delegate;

+ (CustomAlertView *)createInView:(UIView *)owner withImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle discard:(NSString *)discard confirm:(NSString *)confirm;

- (void)show;
- (void)dismiss;
@end
