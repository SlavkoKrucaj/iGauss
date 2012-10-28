//
//  ProjectSession+Create.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSession.h"

#define WIDTH 320
#define CELL_MARGIN 20
#define CELL_MIN_HEIGHT 125
#define CELL_NOTE_MIN_HEIGHT 20
#define CELL_NOTE_MARGIN 10
#define CELL_ACTION_BUTTONS_HEIGHT 45
#define CELL_NOTE_FONT ([UIFont systemFontOfSize:15])

@interface ProjectSession (Create)

+ (ProjectSession *)createProjectSessionWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
