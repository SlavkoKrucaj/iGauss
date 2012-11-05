//
//  BillingPoint+Manipulation.m
//  iGauss
//
//  Created by Slavko Krucaj on 5.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "BillingPoint+Manipulation.h"

@implementation BillingPoint (Manipulation)

+ (BillingPoint *)billingPointForId:(NSNumber *)billingPointId inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BillingPoint"];
    request.predicate = [NSPredicate predicateWithFormat:@"billingPointId = %@", billingPointId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"billingPointId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *projects = [context executeFetchRequest:request error:&error];
    
    
    if (projects.count == 1) {
        return [projects lastObject];
    }
    
    return nil;
}

@end
