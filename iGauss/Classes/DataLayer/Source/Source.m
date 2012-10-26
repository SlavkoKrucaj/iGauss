//
//  Source.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Source.h"
#import "AFNetworking.h"
#import "Model.h"

NSString *const SourceTypeGet  = @"GET";
NSString *const SourceTypePost = @"POST";

@interface Source()
@property (nonatomic, strong) NSString *sourceType;
@property (nonatomic, strong) AFHTTPRequestOperation *networkOperation;
@end

@implementation Source

- (id)initSourceInMode:(NSString *)sourceType {
    if (self = [super init]) {
        self.sourceType = sourceType;
    }
    return self;
}

- (void)loadAsync {
    
    //check if there are deserializer and error handler and url
    NSAssert(self.url, @"There should be url defined");
    NSAssert(self.deserializer, @"There should be deserializer defined for url -> %@.", self.url);
    NSAssert(self.errorHandler, @"There should be error handler defined for url -> %@.", self.url);
    
    //we are sure all required properties exist
    //we are going to make an api call
    
    if ([self.sourceType isEqualToString:SourceTypeGet]) {
    
        [self makeGetRequest];
        
    } else if ([self.sourceType isEqualToString:SourceTypePost]) {
    
        [self makePostRequest];
        
    } else {
        NSAssert(NO, @"Source cannot process request of type >> %@ <<", self.sourceType);
    }
    
}

- (void)makeGetRequest {
    
#ifdef DEBUG
    //debug just to warn us if we haven't set model
    if (!self.params) {
        NSLog(@"There is no model set");
    }
#endif
    
    if (self.params) {
        NSDictionary *params = [self.params toUrlParams];

        NSMutableString *urlString = [NSMutableString stringWithString:[self.url absoluteString]];
        for (NSString *key in params) {
            
            NSString *searchKey = [NSString stringWithFormat:@":%@", key];
            NSString *replacementKey = [params objectForKey:key];

            [urlString replaceOccurrencesOfString:searchKey
                                       withString:replacementKey
                                          options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(0, urlString.length)];

        }

        if ([urlString hasSuffix:@"/"]) [urlString deleteCharactersInRange:NSMakeRange([urlString length]-1, 1)];
        self.url = [NSURL URLWithString:urlString];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    self.networkOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

#ifdef DEBUG
        NSLog(@"%@ operation hasAcceptableStatusCode: %d", self.url.absoluteString, response.statusCode);
        NSLog(@"response string: %@ ", JSON);
#endif
        
        //check for api specific errors
        NSError *error = nil;
        if ((error = [self.errorHandler processErrorsFromResponse:JSON])) {
#ifdef DEBUG
            NSLog(@"There are custom errors");
#endif
            [self.delegate source:self didFailToLoadWithErrors:error];
            return;
        }
        
        //process response
        [self.delegate source:self didLoadObject:[self.deserializer deserialize:JSON]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

#ifdef DEBUG
        NSLog(@"%@ has errors: %@", self.url.absoluteString, JSON);
#endif
        [self.delegate source:self didFailToLoadWithErrors:error];

    }];
    
    [self.networkOperation start];
}

- (void)makePostRequest {
    
#ifdef DEBUG
    //debug just to warn us if we haven't set model
    if (!self.params) {
        NSLog(@"There is no model set");
    }
#endif
    
    NSAssert(self.baseUrl, @"There should be a base url when doing post request");
    __block Source *blockSource = self;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:self.baseUrl];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSDictionary *params = [self.params toUrlParams];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:self.url.absoluteString parameters:params];
    
    self.networkOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [self.networkOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        id JSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];

#ifdef DEBUG
        NSLog(@"%@ operation hasAcceptableStatusCode: %d", blockSource.url.absoluteString, operation.response.statusCode);
        NSLog(@"response string: %@ ", JSON);
#endif
        
        //check for api specific errors
        NSError *error = nil;
        if ((error = [blockSource.errorHandler processErrorsFromResponse:JSON])) {
#ifdef DEBUG
            NSLog(@"There are custom errors");
#endif
            [blockSource.delegate source:blockSource didFailToLoadWithErrors:error];
            return;
        }
        
        //process response
        [blockSource.delegate source:blockSource didLoadObject:[blockSource.deserializer deserialize:JSON]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
#ifdef DEBUG
        NSLog(@"%@ has errors: %@", blockSource.url.absoluteString, error.localizedDescription);
#endif
        [self.delegate source:blockSource didFailToLoadWithErrors:error];
    }];

    [self.networkOperation start];

}

@end
