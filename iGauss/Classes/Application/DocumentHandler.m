//
//  DocumentHandler.m
//  iOUTracker
//
//  Created by Slavko Krucaj on 8.10.2012..
//  Copyright (c) 2012. Infinum. All rights reserved.
//

#import "DocumentHandler.h"
#import <CoreData/CoreData.h>

@interface DocumentHandler ()

@property (atomic, assign) BOOL isOpening;
@property (nonatomic, retain) NSMutableArray *completionQueue;
@end;

@implementation DocumentHandler

@synthesize document = _document;

static DocumentHandler *_sharedInstance;

+ (DocumentHandler *)sharedDocumentHandler
{
    @synchronized([DocumentHandler class])
	{
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            _sharedInstance = [[self alloc] init];
        });
        
        return _sharedInstance;
    }
}

- (id)init
{
    self = [super init];
    if (self) {

        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"GaussDb.db"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Set our document up for automatic migrations
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.document.persistentStoreOptions = options;
        
        self.completionQueue = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(documentStateDidChange:)
                                                     name:UIDocumentStateChangedNotification
                                                   object:self.document];
    }
    return self;
}

- (void)documentStateDidChange:(NSNotification *)notification {
    if (self.document.documentState == UIDocumentStateNormal) {
        NSLog(@"Document did change state");
        @synchronized (self.document) {
            self.isOpening = NO;
            for (OnDocumentReady documentReady in self.completionQueue) {
                documentReady(self.document);
            }
            [self.completionQueue removeAllObjects];
        }
    }
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document);
    };


    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        if (!self.isOpening) {
            self.isOpening = YES;
            [self.document openWithCompletionHandler:OnDocumentDidLoad];
        } else {
            [self.completionQueue addObject:onDocumentReady];
        }
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }

}
@end