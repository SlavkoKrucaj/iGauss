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

    if ([response isKindOfClass:[NSDictionary class]] && [response objectForKey:@"error"]) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:[response objectForKey:@"error"] forKey:NSLocalizedDescriptionKey];
        return [NSError errorWithDomain:@"api-domain" code:100 userInfo:errorDetail];
    }
    
    return nil;
}

@end
