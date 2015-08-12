//
//  ProgramExecuter.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgramExecuterProtocol.h"


@interface ProgramExecuter : NSObject

- (instancetype)initWithDelegate:(id<ProgramExecuterDelegate>)delegate statementBlock:(NSMutableArray *)block withSpeed:(NSTimeInterval)inteval;
- (BOOL)isStarted;
- (void)start;

@end
