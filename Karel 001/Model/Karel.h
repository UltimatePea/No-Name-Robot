//
//  Karel.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//
//coordinate system starts from bottomleft
#import <Foundation/Foundation.h>


#import "Position.h"
#import "Direction.h"

@import CoreGraphics;

@interface Karel : NSObject

@property (nonatomic) Position *position;
@property (nonatomic) Direction direction;
- (void)move;
- (void)turnLeft;
- (instancetype)initWithPosition:(Position *)position withInitialDirection:(Direction)direction;

@end
