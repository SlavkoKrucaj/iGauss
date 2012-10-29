//
//  LoginParams.h
//  iGauss
//
//  Created by Slavko Krucaj on 25.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface LoginParams : Model

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end