//
//  GaussNavigationCreationProtocol.h
//  iGauss
//
//  Created by Slavko Krucaj on 6.11.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "GaussNavigationBar.h"

#ifndef iGauss_GaussNavigationCreationProtocol_h
#define iGauss_GaussNavigationCreationProtocol_h

@protocol GaussNavigationCreationDelegate <NSObject>

@required
- (void)setupGaussNavigationBar:(GaussNavigationBar *)gaussNavigationBar;

@end


#endif
