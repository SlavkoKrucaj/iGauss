//
//  ProjectSession.h
//  iGauss
//
//  Created by Slavko Krucaj on 29.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface ProjectSession : NSManagedObject

@property (nonatomic, retain) NSNumber * cellHeight;
@property (nonatomic, retain) NSNumber * noteHeight;
@property (nonatomic, retain) NSDate * sessionDate;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSString * sessionNote;
@property (nonatomic, retain) NSString * sessionTime;
@property (nonatomic, retain) NSNumber * timeHeight;
@property (nonatomic, retain) NSNumber * titleHeight;
@property (nonatomic, retain) Project *project;

@end
