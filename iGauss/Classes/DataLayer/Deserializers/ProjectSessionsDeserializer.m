//
//  WorkDeserializer.m
//  iGauss
//
//  Created by Slavko Krucaj on 26.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ProjectSessionsDeserializer.h"
#import "DocumentHandler.h"
#import "ProjectSession+Create.h"

@implementation ProjectSessionsDeserializer

- (void)deserialize:(id)json withBlock:(DeserializerBlock)completion {
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
        
        for (NSDictionary *data in json) {
            for (NSDictionary *sessionData in [data objectForKey:@"sessions"]) {
                [ProjectSession createProjectSessionWithData:sessionData inContext:document.managedObjectContext];
            }
        }
        
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            
            completion(nil);
            
        }];
        
    }];
    
}

@end
