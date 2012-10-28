//
//  LoginDeserializer.m
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "LoginDeserializer.h"
#import "LoginModel.h"

@implementation LoginDeserializer

- (void)deserialize:(id)json withBlock:(DeserializerBlock)completion {
    
    LoginModel *model = [[LoginModel alloc] init];
    model.token = [json valueForKeyPath:@"auth_token"];
    
    completion(model);
}

@end
