//
//  StatementIdentifier.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "StatementIdentifier.h"

@implementation StatementIdentifier

+ (NSArray *)supportedIdentifiers{
    return [NSArray arrayWithObjects:@"turn left", @"move",  @"for", @"if", @"while", @"pick beeper", @"put beeper", nil];
}

+ (NSArray *)supportedIdentifiersOfTypeCommand
{
    return [NSArray arrayWithObjects:@"turn left", @"move", @"pick beeper", @"put beeper", nil];
}

+ (NSArray *)supportedIdentifiersOfTypeCondition
{
    return [NSArray arrayWithObjects:@"front is blocked", @"front is clear", nil];
}

+ (BOOL)isIdentifierConditionFamily:(NSString *)identifier
{
    return [[self supportedIdentifiersOfTypeCondition] containsObject:identifier];
}

@end
