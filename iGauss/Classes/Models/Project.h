//
//  Project.h
//  iGauss
//
//  Created by Slavko Krucaj on 5.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSSet *billingPoints;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addBillingPointsObject:(NSManagedObject *)value;
- (void)removeBillingPointsObject:(NSManagedObject *)value;
- (void)addBillingPoints:(NSSet *)values;
- (void)removeBillingPoints:(NSSet *)values;

@end
