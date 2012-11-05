//
//  App.h
//  phot
//
//  Created by Slavko Krucaj on 9.10.2012..
//  Copyright (c) 2012. Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GaussAuthToken;
extern NSString *const GaussUsername;
extern NSString *const GaussEmail;
extern NSString *const GaussAvatar;

@interface App  : NSObject

+ (App*) instance;

@end
