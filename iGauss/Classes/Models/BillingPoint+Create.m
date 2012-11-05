//
//  BillingPoint+Create.m
//  iGauss
//
//  Created by Slavko Krucaj on 5.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "BillingPoint+Create.h"
#import "Project+Manipulation.h"

@implementation BillingPoint (Create)

+ (BillingPoint *)createBillingPointWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context {
    
    BillingPoint *billingPoint = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BillingPoint"];
    request.predicate = [NSPredicate predicateWithFormat:@"billingPointId = %@", [data objectForKey:@"id"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"billingPointId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        billingPoint = [NSEntityDescription insertNewObjectForEntityForName:@"BillingPoint" inManagedObjectContext:context];
        billingPoint.billingPointId = [data objectForKey:@"id"];
        billingPoint.billingPointName = [data objectForKey:@"name"];
        billingPoint.billingPointFullName = [data objectForKey:@"full_name"];
        billingPoint.project = [data objectForKey:@"project"];
    } else {
        billingPoint = [matches lastObject];
        
        NSString *billingPointName = [data objectForKey:@"name"];
        if (![billingPointName isEqualToString:billingPoint.billingPointName]) {
            billingPoint.billingPointName = billingPointName;
        }
        
        NSString *billingPointFullName = [data objectForKey:@"full_name"];
        if (![billingPointFullName isEqualToString:billingPoint.billingPointFullName]) {
            billingPoint.billingPointFullName = billingPointFullName;
        }
        
        NSNumber *billingPointProject = ((Project *)[data objectForKey:@"project"]).projectId;
        if (![billingPointProject isEqualToNumber:billingPoint.project.projectId]) {
            billingPoint.project = [Project projectForId:billingPointProject inContext:context];
        }
    }
    
    return billingPoint;
    
}

@end
