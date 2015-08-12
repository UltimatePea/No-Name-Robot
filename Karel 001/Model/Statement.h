//
//  Statement.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatementIdentifier.h"


@interface Statement : NSObject

@property (strong, nonatomic) NSString *identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
/**
 For the time being, specify type = Function
 */
- (instancetype)initWithIdentifier:(NSString *)identifier withType:(StatementType)type;

@property (nonatomic) StatementType type;

@end
