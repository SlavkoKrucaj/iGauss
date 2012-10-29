//
//  UIImageView+Animated.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "UIImageView+GaussAnimated.h"

@implementation UIImageView (GaussAnimated)

- (void)animateLogo {
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"s01.png"],
                             [UIImage imageNamed:@"s02.png"],
                             [UIImage imageNamed:@"s03.png"],
                             [UIImage imageNamed:@"s04.png"],
                             [UIImage imageNamed:@"s05.png"],
                             [UIImage imageNamed:@"s06.png"],
                             [UIImage imageNamed:@"s07.png"],
                             [UIImage imageNamed:@"s08.png"],
                             [UIImage imageNamed:@"s09.png"],
                             [UIImage imageNamed:@"s10.png"],
                             [UIImage imageNamed:@"s11.png"],
                             [UIImage imageNamed:@"s12.png"],
                             [UIImage imageNamed:@"s13.png"],
                             [UIImage imageNamed:@"s14.png"],
                             [UIImage imageNamed:@"s15.png"],
                             nil];

    self.image = nil;
    self.animationImages = imageArray;
	self.animationDuration = 0.6;
    self.animationRepeatCount = 0;

	[self startAnimating];
}

- (void)stopAnimatingLogo {

    [self stopAnimating];
    self.image = [UIImage imageNamed:@"gauss_face"];
}

@end
