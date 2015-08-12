//
//  Position.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/31/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "Position.h"

@implementation Position


- (instancetype)initWithX:(NSUInteger)x withY:(NSUInteger)y
{
    self = [super init];
    if (self) {
        self.xCoordinate = x;
        self.yCoordinate = y;
        
    }
    return self;
}

- (BOOL)isEqualToPosition:(Position *)position
{
    if (self.xCoordinate==position.xCoordinate && self.yCoordinate == position.yCoordinate) {
        return YES;
    }
    return NO;
}



@end
