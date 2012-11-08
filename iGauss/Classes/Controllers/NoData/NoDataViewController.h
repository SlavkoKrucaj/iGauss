//
//  NoDataViewController.h
//  iGauss
//
//  Created by Slavko Krucaj on 8.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GaussNavigationCreationProtocol.h"

@interface NoDataViewController : UIViewController <GaussNavigationCreationDelegate>

+ (NoDataViewController *)noDataWithDescription:(NSString *)description;

@end
