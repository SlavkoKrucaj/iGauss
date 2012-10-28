//
//  ProjectSession+Create.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSession+Create.h"
#import "Project+Manipulation.h"

@implementation ProjectSession (Create)

+ (ProjectSession *)createProjectSessionWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context {
    
    ProjectSession *session = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"ProjectSession"];
    request.predicate = [NSPredicate predicateWithFormat:@"sessionId = %@", [data objectForKey:@"id"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sessionId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        
        
        session = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectSession" inManagedObjectContext:context];
        

        
        session.sessionId = [data objectForKey:@"id"];
        session.sessionNote = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        session.sessionDate = [dateFormatter dateFromString:[data objectForKey:@"date"]];
        session.sessionTime = [data objectForKey:@"time"];

        
        CGFloat noteHeight = [self calculateNoteHeight:session.sessionNote];
        CGFloat cellHeight = noteHeight + 3*CELL_MARGIN + CELL_ACTION_BUTTONS_HEIGHT;
        session.cellHeight = @(cellHeight);
        session.noteHeight = @(noteHeight);
        
        session.project = [Project projectForId:[data objectForKey:@"project_id"] inContext:context];
        
    } else {
        
        session = [matches lastObject];
        
        NSString *note = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        if (![note isEqualToString:session.sessionNote]) {

            session.sessionNote = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
            
            CGFloat noteHeight = [self calculateNoteHeight:session.sessionNote];
            CGFloat cellHeight = noteHeight + 3*CELL_MARGIN + CELL_ACTION_BUTTONS_HEIGHT;
            session.cellHeight = @(cellHeight);
            session.noteHeight = @(noteHeight);
        
        }
        
        NSDate *date = [dateFormatter dateFromString:[data objectForKey:@"date"]];
        if ([date compare:session.sessionDate] != NSOrderedSame) {
            session.sessionDate = date;
        }
        
        NSNumber *time = [data objectForKey:@"time"];
        if (time.intValue != session.sessionTime.intValue) {
            session.sessionTime = time;
        }
        
        NSNumber *projectId = [data objectForKey:@"project_id"];
        if (projectId.intValue != session.project.projectId.intValue) {
            session.project = [Project projectForId:projectId inContext:context];
        }
    
    
    }
    
    return session;
    
}

+ (CGFloat)calculateNoteHeight:(NSString *)string {
    CGSize constraint = CGSizeMake(WIDTH - (CELL_MARGIN * 2), MAXFLOAT);
    
    CGSize size = [string sizeWithFont:CELL_NOTE_FONT constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, CELL_NOTE_MIN_HEIGHT);
    
    return height + (CELL_NOTE_MARGIN * 2);
}

@end
