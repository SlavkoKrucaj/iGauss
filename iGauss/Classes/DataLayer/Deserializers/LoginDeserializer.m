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

- (DataContainer *)deserialize:(id)json {
    
    LoginModel *model = [[LoginModel alloc] init];
    model.token = [json valueForKeyPath:@"data.token"];
    
    return model;
}

@end
