//
//  Project+Create.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Project.h"

@interface Project (Create)

+ (Project *)createProjectWithData:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;

@end
