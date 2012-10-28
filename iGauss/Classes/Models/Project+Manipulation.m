//
//  Project+Manipulation.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Project+Manipulation.h"

@implementation Project (Manipulation)

+ (Project *)projectForId:(NSNumber *)projectId inContext:(NSManagedObjectContext *)context {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.predicate = [NSPredicate predicateWithFormat:@"projectId = %@", projectId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"projectId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *projects = [context executeFetchRequest:request error:&error];
    

    if (projects.count == 1) {
        return [projects lastObject];
    }
    
    return nil;
}

@end
