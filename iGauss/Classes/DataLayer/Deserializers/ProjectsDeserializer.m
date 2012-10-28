
//  ProjectsDeserializer.m
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectsDeserializer.h"
#import "Store.h"
#import "Project+Create.h"
#import "DocumentHandler.h"

@implementation ProjectsDeserializer

- (DataContainer *)deserialize:(id)json {
    [self deserialize:json withBlock:nil];
    return nil;
}

- (void)deserialize:(id)json withBlock:(DeserializerBlock)completion {
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        
        for (NSDictionary *dictionary in json) {
            
            [Project createProjectWithData:dictionary inContext:document.managedObjectContext];
            
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            
            completion(nil);
            
        }];
        
    }];
}

@end
