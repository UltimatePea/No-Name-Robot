//
//  StatementWithConditionAndCommand.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/20/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "StatementWithConditionAndCommand.h"

@implementation StatementWithConditionAndCommand

- (StatementType)type
{
    if ([self.identifier isEqualToString:@"if"]) {
        return StatementTypeIf;
    } else if ([self.identifier isEqualToString:@"for"]){
        return StatementTypeFor;
    } else if ([self.identifier isEqualToString:@"while"]){
        return StatementTypeWhile;
    } else {
        return [super type];
    }
}

- (void)setCondition:(NSString *)condition
{
    _condition = condition;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STATEMENT_CONDITION_CHANGED object:self];
}

- (void)setCommand:(NSString *)command
{
    _command = command;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STATEMENT_COMMAND_CHANGED object:self];
}

@end
