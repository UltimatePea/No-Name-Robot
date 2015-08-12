//
//  Karel.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "Karel.h"

@implementation Karel

- (instancetype)initWithPosition:(Position *)position withInitialDirection:(Direction)direction
{
    self = [super init];
    if (self) {
        self.position = position;
        self.direction = direction;
    }
    return self;
}

- (void)move
{
    switch (self.direction) {
        case DirectionNorth:
          //  self.position = CGPointMake(self.position.x, self.position.y+1);
            self.position = [[Position alloc] initWithX:self.position.xCoordinate withY:self.position.yCoordinate + 1];
            break;
        case DirectionEast:
           // self.position = CGPointMake(self.position.x + 1, self.position.y);
            self.position = [[Position alloc] initWithX:self.position.xCoordinate + 1 withY:self.position.yCoordinate];
            break;
        case DirectionSouth:
           // self.position = CGPointMake(self.position.x, self.position.y - 1);
            self.position = [[Position alloc] initWithX:self.position.xCoordinate withY:self.position.yCoordinate - 1];
            break;
        case DirectionWest:
          //  self.position = CGPointMake(self.position.x - 1, self.position.y);
            self.position = [[Position alloc] initWithX:self.position.xCoordinate - 1 withY:self.position.yCoordinate];
            break;
        default:
            break;
    }
}

- (void)turnLeft
{
    switch (self.direction) {
        case DirectionNorth:
            self.direction = DirectionWest;
            break;
        case DirectionEast:
            self.direction = DirectionNorth;
            break;
        case DirectionSouth:
            self.direction = DirectionEast;
            break;
        case DirectionWest:
            self.direction = DirectionSouth;
            break;
        default:
            break;
    }
}

@end
