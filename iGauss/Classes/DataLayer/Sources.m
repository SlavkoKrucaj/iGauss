//
//  Sources.m
//  iGauss
//
//  Created by Slavko Krucaj on 23.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "Sources.h"
#import "Source.h"
#import "iGaussErrorHandler.h"
#import "LoginDeserializer.h"
#import "ProjectsDeserializer.h"
#import "ProjectSessionsDeserializer.h"

@implementation Sources

+ (Source *)createLoginSource {
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/login?email=:email&password=:password"];
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[LoginDeserializer alloc] init];
    
    return source;
}

+ (Source *)createProjectsSource {
    
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/projects?auth_token=:auth_token"];
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[ProjectsDeserializer alloc] init];
    
    return source;
    
}

+ (Source *)createProjectSessionsSource {
    
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/project_sessions?auth_token=:auth_token"];
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[ProjectSessionsDeserializer alloc] init];
    
    return source;
    
}
@end
