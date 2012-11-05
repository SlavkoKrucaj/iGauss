//
//  LoginModel.h
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Model.h"

@interface LoginModel : Model

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *avatarUrl;

@end
