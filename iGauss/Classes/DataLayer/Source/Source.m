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
    
    //debug just to warn us if we haven't set model
    if (!self.params) {
        LOG(@"There is no model set");
    }
    
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
    __block Source *blockSource = self;
    
    self.networkOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        LOG(@"%@ operation hasAcceptableStatusCode: %d", self.url.absoluteString, response.statusCode);
        LOG(@"response string: %@ ", JSON);

        
        //check for api specific errors
        NSError *error = nil;
        if ((error = [self.errorHandler processErrorsFromResponse:JSON])) {

            LOG(@"There are custom errors");

            [self.delegate source:self didFailToLoadWithErrors:error];
            return;
        }
        
        [blockSource.deserializer deserialize:JSON withBlock:^(DataContainer *data){
            if (blockSource.nextSource) {
                [blockSource.delegate intermediateSource:blockSource didLoadObject:data];
                [blockSource.nextSource loadAsync];
            } else {
                [blockSource.delegate source:blockSource didLoadObject:data];
            }
        }];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {

        LOG(@"%@ has errors: %@", self.url.absoluteString, JSON);

        [self.delegate source:self didFailToLoadWithErrors:error];

    }];
    
    [self.networkOperation start];
}

- (void)makePostRequest {
    
    if (!self.params) {
        LOG(@"There is no model set");
    }
    
    NSAssert(self.baseUrl, @"There should be a base url when doing post request");
    __block Source *blockSource = self;
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:self.baseUrl];
    [httpClient defaultValueForHeader:@"Accept"];
    
    NSDictionary *params = [self.params toUrlParams];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:self.url.absoluteString parameters:params];
    
    self.networkOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [self.networkOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        id JSON = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];

        LOG(@"%@ operation hasAcceptableStatusCode: %d", blockSource.url.absoluteString, operation.response.statusCode);
        LOG(@"response string: %@ ", JSON);
        
        //check for api specific errors
        NSError *error = nil;
        if ((error = [blockSource.errorHandler processErrorsFromResponse:JSON])) {
            
            [blockSource.delegate source:blockSource didFailToLoadWithErrors:error];
        
            return;
        }
        
        //process response
        [blockSource.deserializer deserialize:JSON withBlock:^(DataContainer *data){
            if (blockSource.nextSource) {
                [blockSource.delegate intermediateSource:blockSource didLoadObject:data];
                [blockSource.nextSource loadAsync];
            } else {
                [blockSource.delegate source:blockSource didLoadObject:data];
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LOG(@"%@ has errors: %@", blockSource.url.absoluteString, error.localizedDescription);
        
        [self.delegate source:blockSource didFailToLoadWithErrors:error];
    }];

    [self.networkOperation start];

}

@end
