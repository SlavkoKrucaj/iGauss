//
//  Store.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Store.h"

@implementation Store

- (id)init {
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)addItem:(Model *)item {
    [self.items addObject:item];
}

- (void)removeItem:(Model *)item {
    [self.items removeObject:item];
}

- (void)removeItemAtIndex:(int)index {
    NSAssert(index < self.items.count, @"Index is bigger than items.size");
    [self.items removeObjectAtIndex:index];
}

- (NSInteger)count {
    return self.items.count;
}
@end
