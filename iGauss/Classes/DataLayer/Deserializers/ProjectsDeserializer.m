//
//  ProjectsDeserializer.m
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectsDeserializer.h"
#import "ProjectsModel.h"
#import "Store.h"

@implementation ProjectsDeserializer

- (DataContainer *)deserialize:(id)json {
    
    Store *returnStore = [[Store alloc] init];

    for (NSDictionary *dictionary in [json objectForKey:@"data"]) {
        ProjectsModel *model = [[ProjectsModel alloc] init];
        model.projectName = [dictionary objectForKey:@"projectName"];
        [returnStore addItem:model];
    }
    
    return returnStore;
}

@end
