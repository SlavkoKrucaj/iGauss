//
//  WorkDay.h
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Model.h"
#import "Store.h"

@interface WorkDay : Model

@property (nonatomic, strong) NSString *workDate;
@property (nonatomic, strong) Store *work;

@end
