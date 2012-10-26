//
//  Work.h
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Model.h"

@interface Work : Model

@property (nonatomic, strong) NSString *project;
@property (nonatomic, strong) NSString *billing;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSDate   *date;
@property (nonatomic, strong) NSString *workDescription;

@end
