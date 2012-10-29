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
        
        NSInteger time = [[data objectForKey:@"time"] intValue];
        
        session.sessionId = [data objectForKey:@"id"];
        session.sessionNote = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        session.sessionDate = [dateFormatter dateFromString:[data objectForKey:@"date"]];
        session.sessionTime = [NSString stringWithFormat:@"- %.02d:%02d", time/60, time%60];

        session.project = [Project projectForId:[data objectForKey:@"project_id"] inContext:context];
        
        CGFloat titleHeight = [self calculateNoteHeight:session.project.projectFullName withFont:CELL_TITLE_FONT];
        CGFloat timeHeight = [self calculateNoteHeight:session.sessionTime withFont:CELL_TIME_FONT];
        CGFloat noteHeight = [self calculateNoteHeight:session.sessionNote withFont:CELL_NOTE_FONT] + 2*CELL_NOTE_MARGIN;

        CGFloat cellHeight = noteHeight + titleHeight + timeHeight + 3*CELL_MARGIN + CELL_ACTION_BUTTONS_HEIGHT;
        session.cellHeight = @(cellHeight);
        session.noteHeight = @(noteHeight);
        session.timeHeight = @(timeHeight);
        session.titleHeight = @(titleHeight);
        
        
    } else {
        session = [matches lastObject];
        
        CGFloat titleHeight = [self calculateNoteHeight:session.project.projectFullName withFont:CELL_TITLE_FONT] + 2*CELL_TITLE_MARGIN;
        CGFloat timeHeight = [self calculateNoteHeight:session.sessionTime withFont:CELL_TIME_FONT] + 2*CELL_TIME_MARGIN;
        CGFloat noteHeight = [self calculateNoteHeight:session.sessionNote withFont:CELL_NOTE_FONT];
        
        NSString *note = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
        if (![note isEqualToString:session.sessionNote]) {

            session.sessionNote = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
            
            CGFloat cellHeight = noteHeight + titleHeight + timeHeight + 3*CELL_MARGIN + CELL_ACTION_BUTTONS_HEIGHT + CELL_NOTE_MARGIN;
            session.cellHeight = @(cellHeight);
            session.noteHeight = @(noteHeight);
            session.timeHeight = @(timeHeight);
            session.titleHeight = @(titleHeight);
        
        }
        
        NSNumber *time = [data objectForKey:@"time"];
        if (time.intValue != session.sessionTime.intValue) {
            
            NSInteger time = [[data objectForKey:@"time"] intValue];
            session.sessionTime = [NSString stringWithFormat:@"- %.02d:%02d", time/60, time%60];
            
            CGFloat cellHeight = noteHeight + titleHeight + timeHeight + 3*CELL_MARGIN + CELL_ACTION_BUTTONS_HEIGHT;
            session.cellHeight = @(cellHeight);
            session.noteHeight = @(noteHeight);
            session.timeHeight = @(timeHeight);
            session.titleHeight = @(titleHeight);
            
        }
        
        NSDate *date = [dateFormatter dateFromString:[data objectForKey:@"date"]];
        if ([date compare:session.sessionDate] != NSOrderedSame) {
            session.sessionDate = date;
        }
        
        NSNumber *projectId = [data objectForKey:@"project_id"];
        if (projectId.intValue != session.project.projectId.intValue) {
            session.project = [Project projectForId:projectId inContext:context];
        }
    
    
    }
    
    return session;
    
}

+ (CGFloat)calculateNoteHeight:(NSString *)string withFont:(UIFont *)font {
    CGSize constraint = CGSizeMake(WIDTH - (CELL_MARGIN * 2 + 2*CELL_NOTE_MARGIN), MAXFLOAT);
    
    CGSize size = [string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, CELL_NOTE_MIN_HEIGHT);
    
    return height;
}

@end
