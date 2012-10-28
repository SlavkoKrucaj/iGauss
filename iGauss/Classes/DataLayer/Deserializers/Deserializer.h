//
//  Deserializer.h
//  iGauss
//
//  Created by Slavko Krucaj on 28.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataContainer.h"

typedef void (^ DeserializerBlock)(DataContainer *);

@interface Deserializer : NSObject

- (void)deserialize:(id)json withBlock:(DeserializerBlock)completion;

@end