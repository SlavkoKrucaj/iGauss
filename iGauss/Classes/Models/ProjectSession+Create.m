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
    
    } else {

        session = [matches lastObject];
#warning tu je return jer inace uvijek prepise nove podatke sa starima sa servera
        return session;

    }

    NSInteger time = [[data objectForKey:@"time"] intValue];
        
    session.sessionId = [data objectForKey:@"id"];
    session.sessionNote = [[data objectForKey:@"note"] stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    session.sessionDate = [dateFormatter dateFromString:[data objectForKey:@"date"]];
    session.sessionTime = [NSString stringWithFormat:@"- %.02d:%02d", time/60, time%60];
    session.project = [Project projectForId:[data objectForKey:@"project_id"] inContext:context];

    [self updateHeights:session];
    
    return session;
    
}

+ (ProjectSession *)createLocallyWithData:(NSMutableDictionary *)data inContext:(NSManagedObjectContext *)context {

    ProjectSession *session = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectSession" inManagedObjectContext:context];
    
    session.sessionNote = [data objectForKey:@"sessionNote"];
    session.sessionDate = [data objectForKey:@"sessionDate"];
    session.sessionTime = [data objectForKey:@"sessionTime"];
    
    session.project = [Project projectForId:((Project *)[data objectForKey:@"project"]).projectId inContext:context];
    
    [self updateHeights:session];
    
    return session;

}

+ (void)updateHeights:(ProjectSession *)session {
    CGFloat titleHeight = [self calculateNoteHeight:session.project.projectFullName withFont:CELL_TITLE_FONT];
    CGFloat timeHeight = [self calculateNoteHeight:session.sessionTime withFont:CELL_TIME_FONT];
    CGFloat noteHeight = [self calculateNoteHeight:session.sessionNote withFont:CELL_NOTE_FONT];
    
    CGRect titleRect = CGRectMake(CELL_INTERNAL_MARGIN,CELL_INTERNAL_MARGIN,CELL_CONTENT_WIDTH, titleHeight);
    CGRect timeRect  = CGRectMake(CELL_INTERNAL_MARGIN,CGRectGetMaxY(titleRect),CELL_CONTENT_WIDTH, timeHeight + 2*CELL_TIME_MARGIN);
    CGRect noteRect = CGRectMake(CELL_INTERNAL_MARGIN, CGRectGetMaxY(timeRect), CELL_CONTENT_WIDTH, noteHeight + 2*CELL_TIME_MARGIN);
    
    CGRect buttonHolderRect = CGRectMake(0, CGRectGetMaxY(noteRect) + CELL_INTERNAL_MARGIN, CELL_WIDTH - 2*CELL_MARGIN, CELL_ACTION_BUTTONS_HEIGHT);
    
    CGRect holderRect = CGRectMake(CELL_MARGIN, CELL_MARGIN, CELL_WIDTH - 2*CELL_MARGIN, CGRectGetMaxY(buttonHolderRect));
    
    session.titleFrame = NSStringFromCGRect(titleRect);
    session.timeFrame = NSStringFromCGRect(timeRect);
    session.noteFrame = NSStringFromCGRect(noteRect);
    session.buttonFrame = NSStringFromCGRect(buttonHolderRect);
    session.holderFrame = NSStringFromCGRect(holderRect);
    session.contentHeight = @(CGRectGetMaxY(buttonHolderRect) + 2*CELL_MARGIN);
}

+ (CGFloat)calculateNoteHeight:(NSString *)string withFont:(UIFont *)font {
    CGSize constraint = CGSizeMake(CELL_WIDTH - (CELL_MARGIN * 2 + 2*CELL_INTERNAL_MARGIN), MAXFLOAT);
    
    CGSize size = [string sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, CELL_NOTE_MIN_HEIGHT);
    
    return height;
}

@end
