//
//  KarelWorldMap.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Karel.h"
#import "Position.h"
#import "KarelWorldWall.h"
#import "Beeper.h"
@interface KarelWorldMap : NSObject

@property (strong, nonatomic) NSString *mapSerial;


@property (nonatomic) NSUInteger width;
@property (nonatomic) NSUInteger height;

@property (strong, nonatomic) NSMutableArray *walls;//containing karelWorldWalls;
@property (strong, nonatomic) NSMutableArray *beepers;

@property (strong, nonatomic) NSMutableArray *finalBeepers;

@property (strong, nonatomic) Position *initialPosition;
@property (strong, nonatomic) Position *finalDestination;


- (instancetype)initWithMap:(NSString *)mapInfoPlist;
- (BOOL)isWallPresented:(KarelWorldWall *)wall;

- (BOOL)isBeepersMovedToSatisfiedPosition;//returns true if initial and fianl beepers contains nothing


- (void)reload;
@end
