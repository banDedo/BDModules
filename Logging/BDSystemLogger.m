//
//  BDSystemLogger.m
//  Plank
//
//  Created by Patrick Hogan on 12/31/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

#import <asl.h>

#import "BDSystemLogger.h"

@interface BDSystemLogger ()

@property (nonatomic) aslclient client;

@end

@implementation BDSystemLogger

#pragma mark - Constructor

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.client = asl_open(NULL, "com.apple.console", 0);
    }
    
    return self;
}

#pragma mark - Logging

- (void)logMessage:(NSString *)message level:(NSInteger)level
{
    int aslLogLevel;
    switch (level)
    {
        case 3:
            aslLogLevel = ASL_LEVEL_CRIT;
            break;
        case 2:
            aslLogLevel = ASL_LEVEL_ERR;
            break;
        case 1:
            aslLogLevel = ASL_LEVEL_WARNING;
            break;
        default:
            aslLogLevel = ASL_LEVEL_NOTICE;
            break;
    }
    
    asl_log(self.client, NULL, aslLogLevel,"%s\n", message.UTF8String);
}

@end
