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
    model.email = [json valueForKeyPath:@"email"];
    model.firstName = [json valueForKeyPath:@"first_name"];
    model.lastName = [json valueForKeyPath:@"last_name"];
    model.avatarUrl = [json valueForKeyPath:@"avatar_url"];
    
    completion(model);
}

@end
