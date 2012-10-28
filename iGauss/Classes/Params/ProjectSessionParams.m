//
//  ProjectSessionParams.m
//  iGauss
//
//  Created by Slavko Krucaj on 27.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSessionParams.h"

NSString *const GaussToken     = @"auth_token";

@implementation ProjectSessionParams

- (NSDictionary *)toUrlParams {
    
    if (!self.authToken) self.authToken = @"";
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.authToken,     GaussToken,
            nil];
}

@end
