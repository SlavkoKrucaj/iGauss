//
//  UIView+Frame.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setHeight:(CGFloat)height {
    CGRect frameTemp = self.frame;
    frameTemp.size.height = height;
    self.frame = frameTemp;
}

- (void)setWidth:(CGFloat)width {
    CGRect frameTemp = self.frame;
    frameTemp.size.width = width;
    self.frame = frameTemp;
}

- (void)setX:(CGFloat)x {
    CGRect frameTemp = self.frame;
    frameTemp.origin.x = x;
    self.frame = frameTemp;
}

- (void)setY:(CGFloat)y {
    CGRect frameTemp = self.frame;
    frameTemp.origin.y = y;
    self.frame = frameTemp;
}
@end
