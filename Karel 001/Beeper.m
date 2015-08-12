//
//  Beeper.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/31/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "Beeper.h"

@interface Beeper ()



@end

@implementation Beeper


- (instancetype)initWithPosition:(Position *)position
{
    self = [super init];
    if (self) {
        self.position = position;
    }
    return self;
    
}

@end
