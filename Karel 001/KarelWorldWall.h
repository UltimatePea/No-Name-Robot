//
//  KarelWorldWall.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/30/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Direction.h"
#import "Position.h"
/*
typedef enum : NSUInteger {
    KarelWorldWallDirectionNorthToSouth = 2,
    KarelWorldWallDirectionSouthToNorth = 4,
    KarelWorldWallDirectionWestToEast = 1,
    KarelWorldWallDirectionEastToWest = 3,
} KarelWorldWallDirection;
*/
@interface KarelWorldWall : NSObject


- (instancetype)initWithPosition:(Position *)position withDirection:(Direction)direction;
@property (nonatomic) Position *position;
@property (nonatomic) Direction direction;



@end
