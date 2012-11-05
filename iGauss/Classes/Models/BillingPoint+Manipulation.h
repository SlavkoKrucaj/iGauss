//
//  BillingPoint+Manipulation.h
//  iGauss
//
//  Created by Slavko Krucaj on 5.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "BillingPoint.h"

@interface BillingPoint (Manipulation)

+ (BillingPoint *)billingPointForId:(NSNumber *)billingPointId inContext:(NSManagedObjectContext *)context;

@end
