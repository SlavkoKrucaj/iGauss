//
//  WorkDeserializer.m
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "WorkDeserializer.h"
#import "WorkDay.h"
#import "Work.h"

@implementation WorkDeserializer

- (DataContainer *)deserialize:(id)json {
    
    Store *returnStore = [[Store alloc] init];
    
    NSArray *days = [json objectForKey:@"days"];
    
    for (NSDictionary *day in days) {
        
        WorkDay *workDay = [[WorkDay alloc] init];
        workDay.workDate = [day objectForKey:@"date"];
        workDay.work = [[Store alloc] init];
        
        NSArray *workingHours = [day objectForKey:@"working_hours"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd.MM.yyyy.";
        for (NSDictionary *workingHour in workingHours) {
            
            Work *work = [[Work alloc] init];
            work.workDescription = [workingHour objectForKey:@"workDescription"];
            work.billing = [workingHour objectForKey:@"billingPoint"];
            work.project = [workingHour objectForKey:@"project"];
            work.time = [workingHour objectForKey:@"time"];
            work.date = [formatter dateFromString:workDay.workDate];
            [workDay.work addItem:work];
            
        }
        
        [returnStore addItem:workDay];
    }

    return returnStore;
}

@end
