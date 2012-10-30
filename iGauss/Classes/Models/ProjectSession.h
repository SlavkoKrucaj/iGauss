//
//  ProjectSession.h
//  iGauss
//
//  Created by Slavko Krucaj on 30.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, WorkDay;

@interface ProjectSession : NSManagedObject

@property (nonatomic, retain) NSString * buttonFrame;
@property (nonatomic, retain) NSNumber * contentHeight;
@property (nonatomic, retain) NSString * holderFrame;
@property (nonatomic, retain) NSString * noteFrame;
@property (nonatomic, retain) NSDate * sessionDate;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSString * sessionNote;
@property (nonatomic, retain) NSString * sessionTime;
@property (nonatomic, retain) NSString * timeFrame;
@property (nonatomic, retain) NSString * titleFrame;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) WorkDay *workDay;

@end
