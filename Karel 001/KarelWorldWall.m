//
//  KarelWorldWall.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/30/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "KarelWorldWall.h"

@interface KarelWorldWall ()



@end

@implementation KarelWorldWall

- (instancetype)initWithPosition:(Position *)position withDirection:(Direction)direction
{
    self = [super init];
    if (self) {
        self.position = position;
        self.direction = direction;
    }
    return self;
}

@end
