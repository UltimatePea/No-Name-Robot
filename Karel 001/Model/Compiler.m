//
//  Compiler.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "Compiler.h"
#import "ProgramManager.h"

@interface Compiler ()



@end

@implementation Compiler

- (NSMutableArray *)statementBlock
{
    if (!_statementBlock) {
        _statementBlock = [[NSMutableArray alloc] init];
        [[ProgramManager sharedManager].statementBlocks setObject:_statementBlock forKey:@"default program"];
        
    }
    return _statementBlock;
}

#pragma mark - single instance
static Compiler *sharedCompiler = nil;

+ (Compiler *)sharedCompiler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedCompiler = [[self alloc] init];
        
    });
    return sharedCompiler;
}


@end
