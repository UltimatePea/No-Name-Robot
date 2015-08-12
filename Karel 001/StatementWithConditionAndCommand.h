//
//  StatementWithConditionAndCommand.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/20/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Statement.h"

#define NOTIFICATION_STATEMENT_CONDITION_CHANGED @"NOTIFICATION_STATEMENT_CONDITION_CHANGED"
#define NOTIFICATION_STATEMENT_COMMAND_CHANGED @"NOTIFICATION_STATEMENT_COMMAND_CHANGED"

@interface StatementWithConditionAndCommand : Statement;

@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) NSString *command;
@property (nonatomic) StatementType type;

@end
