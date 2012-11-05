//
//  Project+Create.m
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Project+Create.h"

@implementation Project (Create)

+ (Project *)createProjectWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context {
    
    Project *project = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    request.predicate = [NSPredicate predicateWithFormat:@"projectId = %@", [data objectForKey:@"id"]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"projectId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || ([matches count] > 1)) {
        // handle error
    } else if ([matches count] == 0) {
        project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
        project.projectId = [data objectForKey:@"id"];
        project.projectName = [data objectForKey:@"name"];
        
    } else {
        project = [matches lastObject];
        
        NSString *projectName = [data objectForKey:@"name"];
        if (![projectName isEqualToString:project.projectName]) {
            project.projectName = projectName;
        }
    }
    
    return project;
    
}

@end
