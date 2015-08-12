//
//  KarelWorldMap.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "KarelWorldMap.h"
#import "KarelWorldWall.h"
#import "Beeper.h"

@interface KarelWorldMap ()

@property (strong, nonatomic) NSURL *mapURL;

@end

@implementation KarelWorldMap
#pragma mark - initiation and setup from plist
- (instancetype)initWithMap:(NSString *)mapInfoPlist{
    NSString *extension;
    self = [super init];
    if (self) {
        if (![mapInfoPlist containsString:@".plist"]) {
            extension = @"plist";
        }
        NSString *completeMapInfoPlist = mapInfoPlist;
        if (![mapInfoPlist containsString:@"Map"]) {
            completeMapInfoPlist = [NSString stringWithFormat:@"Map%@", mapInfoPlist];
        }
        self.mapURL = [[NSBundle mainBundle] URLForResource:completeMapInfoPlist withExtension:extension];
        if (self.mapURL) {//since this method will generate bugs, check width and height instead
            
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:self.mapURL];
            [self setup:dic];
            self.mapSerial = mapInfoPlist;
            if (self.width==0||self.height==0) {
                self = nil;
            }
        } else {//the bus is that if there once exised a map but is deleted, the URL will still be defined.
            self = nil;
        }
    }
    return self;
}

#define WIDTH @"width"
#define HEIGHT @"height"
#define WALLS @"walls"
#define BEEPERS @"beepers"
#define FINAL_BEEPERS @"final beepers"
#define INITIAL_POSITION @"initial position"
#define FINAL_DESTINATION @"final destination"
#define X @"x"
#define Y @"y"


- (void)setup:(NSDictionary *)dictionary
{
  
    self.width = [[dictionary objectForKey:WIDTH] integerValue];
    self.height = [[dictionary objectForKey:HEIGHT] integerValue];
    self.initialPosition = [self getPosition:[dictionary objectForKey:INITIAL_POSITION]];
    self.finalDestination = [self getPosition:[dictionary objectForKey:FINAL_DESTINATION]];
    self.beepers = [self getBeepersFromArray:[dictionary objectForKey:BEEPERS]];
    self.finalBeepers = [self getBeepersFromArray:[dictionary objectForKey:FINAL_BEEPERS]];
    self.walls = [self getWallsFromArray:[dictionary objectForKey:WALLS]];
}

- (Position *)getPosition:(NSDictionary *)dictionary
{
    NSUInteger x = [[dictionary objectForKey:X] integerValue];
    NSUInteger y = [[dictionary objectForKey:Y] integerValue];
    Position *pos = [[Position alloc] initWithX:x withY:y];
    return pos;
}

- (NSMutableArray *)getBeepersFromArray:(NSArray *)array
{
#warning redundant code
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {//obj is a dictionary containing a values x and y
        NSDictionary *dictionary = (NSDictionary *)obj;
        Position *position = [[Position alloc] initWithX:[[dictionary objectForKey:X] integerValue] withY:[[dictionary objectForKey:Y] integerValue]];
        Beeper *beeper = [[Beeper alloc] initWithPosition:position];
        [result addObject:beeper];
        
    }];
    return result;
    
}
#define DIRECTION @"direction"
- (NSMutableArray *)getWallsFromArray:(NSArray *)array
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {//obj is a dictionary containing a values x and y
        NSDictionary *dictionary = (NSDictionary *)obj;
        Position *position = [[Position alloc] initWithX:[[dictionary objectForKey:X] integerValue] withY:[[dictionary objectForKey:Y] integerValue]];
        KarelWorldWall *wall = [[KarelWorldWall alloc] initWithPosition:position withDirection:[[dictionary objectForKey:DIRECTION] integerValue]];
        [result addObject:wall];
        
    }];
    
    [self setupBackgroundBoundary:result];
    
    return result;
}

- (void)setupBackgroundBoundary:(NSMutableArray *)existingWalls
//adding walls boundary to the walls to be rendered
{
    for (int i = 0 ; i < self.width; i ++) {
        Position *bottomPos = [[Position alloc] initWithX:i withY:0];
        KarelWorldWall *bottomWall = [[KarelWorldWall alloc] initWithPosition:bottomPos withDirection:DirectionSouth];
        [existingWalls addObject:bottomWall];
        
        Position *topPos = [[Position alloc] initWithX:i withY:self.height-1];
        KarelWorldWall *topWall = [[KarelWorldWall alloc] initWithPosition:topPos withDirection:DirectionNorth];
        [existingWalls addObject:topWall];
        
    }
    for (int j = 0 ; j < self.height; j ++) {
        Position *westPos = [[Position alloc] initWithX:0 withY:j];
        KarelWorldWall *westWall = [[KarelWorldWall alloc] initWithPosition:westPos withDirection:DirectionWest];
        [existingWalls addObject:westWall];
        
        Position *eastPos = [[Position alloc] initWithX:self.width-1 withY:j];
        KarelWorldWall *eastWall = [[KarelWorldWall alloc] initWithPosition:eastPos withDirection:DirectionEast];
        [existingWalls addObject:eastWall];
        
    }
}

#pragma mark - condition

- (BOOL)isWallPresented:(KarelWorldWall *)wall
{
    //calculate equivalent wall
    
    
    Direction equivalentWallDirection;
    Position *equivalentWallPosition;
    
    switch (wall.direction) {
        case DirectionNorth:
            equivalentWallPosition = [[Position alloc] initWithX:wall.position.xCoordinate withY:wall.position.yCoordinate + 1];
            equivalentWallDirection = DirectionSouth;
            break;
        case DirectionSouth:
            equivalentWallPosition = [[Position alloc] initWithX:wall.position.xCoordinate withY:wall.position.yCoordinate - 1];
            equivalentWallDirection = DirectionNorth;
            break;
        case DirectionEast:
            equivalentWallPosition = [[Position alloc] initWithX:wall.position.xCoordinate + 1 withY:wall.position.yCoordinate];
            equivalentWallDirection = DirectionWest;
            break;
        case DirectionWest:
            equivalentWallPosition = [[Position alloc] initWithX:wall.position.xCoordinate - 1 withY:wall.position.yCoordinate];
            equivalentWallDirection = DirectionEast;
            break;
            
        default:
            break;
    }
    
    KarelWorldWall *equivalentWall = [[KarelWorldWall alloc] initWithPosition:equivalentWallPosition withDirection:equivalentWallDirection];
    
    return [self isWallWithStrictCoordinateAndDirectionPresented:wall] || [self isWallWithStrictCoordinateAndDirectionPresented:equivalentWall];
    
    
}

- (BOOL)isWallWithStrictCoordinateAndDirectionPresented:(KarelWorldWall *)wall
{
    __block BOOL result = NO;
    [self.walls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KarelWorldWall *aWall = (KarelWorldWall *)obj;
        if (wall.position.xCoordinate == aWall.position.xCoordinate && wall.position.yCoordinate == aWall.position.yCoordinate &&wall.direction == aWall.direction ) {
            result = YES;
        }
    }];
    return result;
}

- (BOOL)isBeepersMovedToSatisfiedPosition// if both initial and final contains nothing, return ture;
{
    BOOL result = YES;
    
    for (Beeper *beeperToTest in self.beepers) {
        BOOL subResult = NO;
        for (Beeper *beeperDestination in self.finalBeepers) {
            if ([beeperToTest.position isEqualToPosition:beeperDestination.position]) {
                subResult = YES;
            }
        }
        if (subResult == NO) {
            result = NO;
        }
    }
    return result;
}

- (void)reload
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:self.mapURL];
    [self setup:dic];
}

@end
