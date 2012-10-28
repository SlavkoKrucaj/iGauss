//
//  App.m
//  phot
//
//  Created by Slavko Krucaj on 9.10.2012..
//  Copyright (c) 2012. Infinum. All rights reserved.
//

#import "App.h"

NSString *const GaussAuthToken = @"auth_token";

@implementation App

static App* _instance = nil;

+ (App*) instance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}


- (id)init
{
    if(self == [super init])
    {
        
    }
    return self;
}


- (void)loadApplicationData
{
    
    
}


@end
