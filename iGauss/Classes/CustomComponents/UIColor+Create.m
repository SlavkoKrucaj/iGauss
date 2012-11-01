//
//  UIColor+Create.m
//  iGauss
//
//  Created by Slavko Krucaj on 1.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "UIColor+Create.h"

@implementation UIColor (Create)

+ (UIColor *)withRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255. green:green/255. blue:blue/255. alpha:alpha];
}

@end
