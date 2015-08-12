//
//  StatementIdentifier.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    StatementTypeBasic,
    StatementTypeIf,
    StatementTypeWhile,
    StatementTypeFor,
    StatementTypeFunction,
    StatementTypeFunctionCall
} StatementType;

@interface StatementIdentifier : NSObject

+ (NSArray *)supportedIdentifiers;

+ (NSArray *)supportedIdentifiersOfTypeCommand;
+ (NSArray *)supportedIdentifiersOfTypeCondition;
+ (BOOL)isIdentifierConditionFamily:(NSString *)identifier;
@end
