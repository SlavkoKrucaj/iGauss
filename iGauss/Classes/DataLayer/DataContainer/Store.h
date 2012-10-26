//
//  Store.h
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "DataContainer.h"
#import "Model.h"

@interface Store : DataContainer

@property (nonatomic, strong) NSMutableArray *items;

- (void)addItem:(Model *)item;
- (void)removeItem:(Model *)item;
- (void)removeItemAtIndex:(int)index;

- (NSInteger)count;

@end
