//
//  WorkDay.h
//  iGauss
//
//  Created by Slavko Krucaj on 30.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectSession;

@interface WorkDay : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *projectSessions;
@end

@interface WorkDay (CoreDataGeneratedAccessors)

- (void)addProjectSessionsObject:(ProjectSession *)value;
- (void)removeProjectSessionsObject:(ProjectSession *)value;
- (void)addProjectSessions:(NSSet *)values;
- (void)removeProjectSessions:(NSSet *)values;

@end
