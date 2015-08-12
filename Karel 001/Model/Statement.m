//
//  Statement.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "Statement.h"
#import "ProgramManager.h"

@interface Statement ()

@property (strong, nonatomic) ProgramManager *manager;

@end

@implementation Statement

- (ProgramManager *)executer
{
    return [ProgramManager sharedManager];
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}

/**
 For the time being, specify type = Function
 */
- (instancetype)initWithIdentifier:(NSString *)identifier withType:(StatementType)type
{
    self = [self initWithIdentifier:identifier];
    self.type = type;
    return self;
}



- (StatementType)type
{
    //if I am function call which is set in initializer
    if (_type == StatementTypeFunction) {
        return _type;
    }
    __block StatementType statementType = StatementTypeBasic;
    [[self.executer.statementBlocks allKeys] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *title = obj;
            if ([title isEqualToString:self.identifier]) {
                statementType = StatementTypeFunctionCall;
                BOOL shouldStop = YES;
                stop = &shouldStop;
            }
        }
    }];

    return statementType;
}



@end
