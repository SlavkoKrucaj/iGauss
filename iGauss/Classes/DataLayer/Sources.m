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
#import "App.h"

@implementation Sources

+ (Source *)createLoginSource {
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    if ([App instance].buildVersion == BuildVersionProduction) {
        source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/login?email=:email&password=:password"];
    } else {
        source.url = [NSURL URLWithString:@"http://dl.dropbox.com/u/12771232/gauss_login_demo.json"];
    }
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[LoginDeserializer alloc] init];
    
    return source;
}

+ (Source *)createProjectsSource {
    
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    if ([App instance].buildVersion == BuildVersionProduction) {
        source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/projects?auth_token=:auth_token"];
    } else {
        source.url = [NSURL URLWithString:@"http://dl.dropbox.com/u/12771232/gauss_projects_demo.json"];
    }
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[ProjectsDeserializer alloc] init];
    
    return source;
    
}

+ (Source *)createProjectSessionsSource {
    
    Source *source = [[Source alloc] initSourceInMode:SourceTypeGet];
    
    if ([App instance].buildVersion == BuildVersionProduction) {
        source.url = [NSURL URLWithString:@"http://gauss.infinum.hr/api/project_sessions?auth_token=:auth_token"];
    } else {
        source.url = [NSURL URLWithString:@"http://dl.dropbox.com/u/12771232/gauss_project_sessions_demo.json"];
    }
    source.errorHandler = [[iGaussErrorHandler alloc] init];
    source.deserializer = [[ProjectSessionsDeserializer alloc] init];
    
    return source;
    
}
@end
