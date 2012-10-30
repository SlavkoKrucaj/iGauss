//
//  ProjectSession+Create.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSession.h"

#define CELL_WIDTH 320
#define CELL_MARGIN 20
#define CELL_INTERNAL_MARGIN 10

#define CELL_CONTENT_WIDTH (CELL_WIDTH - 2*CELL_MARGIN - 2*CELL_INTERNAL_MARGIN)
#define CELL_MIN_HEIGHT 125

#define CELL_NOTE_MIN_HEIGHT 20
#define CELL_NOTE_MARGIN 10
#define CELL_ACTION_BUTTONS_HEIGHT 45
#define CELL_TITLE_MARGIN 5
#define CELL_TIME_MARGIN 5

#define CELL_NOTE_FONT ([UIFont fontWithName:@"Arial" size:14])
#define CELL_TITLE_FONT ([UIFont fontWithName:@"GothamMediumHR" size:20])
#define CELL_TIME_FONT ([UIFont fontWithName:@"GothamMediumHR" size:16])

@interface ProjectSession (Create)

+ (ProjectSession *)createProjectSessionWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
+ (ProjectSession *)createLocallyWithData:(NSMutableDictionary *)data inContext:(NSManagedObjectContext *)context;
+ (void)updateHeights:(ProjectSession *)session;

@end
