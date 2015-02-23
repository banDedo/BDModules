//
//  BDSystemLogger.h
//  Plank
//
//  Created by Patrick Hogan on 12/31/14.
//  Copyright (c) 2014 bandedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSystemLogger : NSObject

- (void)logMessage:(NSString *)message level:(NSInteger)level;

@end
