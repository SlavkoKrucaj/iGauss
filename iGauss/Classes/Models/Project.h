//
//  Project.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectSession;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * projectFullName;
@property (nonatomic, retain) NSNumber * projectId;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSSet *projectSessions;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addProjectSessionsObject:(ProjectSession *)value;
- (void)removeProjectSessionsObject:(ProjectSession *)value;
- (void)addProjectSessions:(NSSet *)values;
- (void)removeProjectSessions:(NSSet *)values;

@end
