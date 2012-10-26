//
//  Source.h
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorHandler.h"
#import "Deserializer.h"

//for example purposes we will just use these two http requests;
extern NSString *const SourceTypeGet;
extern NSString *const SourceTypePost;

@class DataContainer;
@class Source;
@class Model;

@protocol SourceDelegate <NSObject>

@required
- (void)source:(Source *)source didLoadObject:(DataContainer *)dataContainer;
- (void)source:(Source *)source didFailToLoadWithErrors:(NSError *)error;

@end

@interface Source : NSObject {
}

//properties that every source needs to have
@property (nonatomic, strong) Model              *params;
@property (nonatomic, strong) NSURL              *url;
@property (nonatomic, strong) NSURL              *baseUrl;
@property (nonatomic, strong) id<Deserializer>   deserializer;
@property (nonatomic, strong) id<ErrorHandler>   errorHandler;
@property (nonatomic, weak)   id<SourceDelegate> delegate;
@property (nonatomic, assign) Class              responseModelClass;

//public methods on source
- (id)initSourceInMode:(NSString *)sourceType;

// for example purposes we will only have asynchronous calls
// but we could also have synchronous calls
- (void)loadAsync;

@end
