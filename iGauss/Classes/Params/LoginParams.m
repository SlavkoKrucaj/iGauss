//
//  LoginParams.m
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "LoginParams.h"

NSString *const GaussSignUpUsername     = @"email";
NSString *const GaussSignUpPassword     = @"password";

@implementation LoginParams

- (NSDictionary *)toUrlParams {
    
    if (!self.username) self.username = @"";
    if (!self.password) self.password = @"";
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.username,     GaussSignUpUsername,
            self.password,     GaussSignUpPassword,
            nil];
}


@end
