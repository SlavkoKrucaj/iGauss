//
//  BillingPoint.h
//  iGauss
//
//  Created by Slavko Krucaj on 5.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, ProjectSession;

@interface BillingPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * billingPointId;
@property (nonatomic, retain) NSString * billingPointName;
@property (nonatomic, retain) NSString * billingPointFullName;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *projectSession;
@end

@interface BillingPoint (CoreDataGeneratedAccessors)

- (void)addProjectSessionObject:(ProjectSession *)value;
- (void)removeProjectSessionObject:(ProjectSession *)value;
- (void)addProjectSession:(NSSet *)values;
- (void)removeProjectSession:(NSSet *)values;

@end
