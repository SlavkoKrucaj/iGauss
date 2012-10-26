//
//  ErrorHandler.h
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ErrorHandler <NSObject>

@required
- (NSError*)processErrorsFromResponse:(id)response;
@end
