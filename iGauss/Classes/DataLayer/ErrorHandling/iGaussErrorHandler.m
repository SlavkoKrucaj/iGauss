//
//  iGaussErrorHandler.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "iGaussErrorHandler.h"

@implementation iGaussErrorHandler

- (NSError *)processErrorsFromResponse:(id)response {
    //if response is an array then it sure isn't error
    if ([response isKindOfClass:[NSArray class]]) return NO;
    
    NSAssert([response isKindOfClass:[NSDictionary class]], @"response should be a dictionary if it's not array");
    
    if (![[response objectForKey:@"success"] boolValue]) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:[response objectForKey:@"errormsg"] forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"api-domain" code:100 userInfo:errorDetail];
    }
    
    return nil;
}

@end
