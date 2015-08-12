//
//  Maze.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/21/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Maze.h"
#import "KarelWorldWall.h"
#import "MazePosition.h"
#import "KarelWorldMap.h"

struct ifChecked {
    BOOL checked;
};

@interface Maze ()

@property (strong, nonatomic) NSMutableArray *nodes;//contains array contains position
@property (strong, nonatomic) NSMutableArray *route;//contains position

@property (strong, nonatomic) KarelWorldMap *map;



@end

@implementation Maze

- (KarelWorldMap *)map
{
    if (!_map) {
        _map = [[KarelWorldMap alloc] initWithMap:@"MapMaze"];
    }
    return _map;
}


- (instancetype)initWithWidht:(NSInteger)width withHeight:(NSInteger)height
{
    self = [super init];
    if (self) {
        
        //setup grid
        for (int i = 0; i < width; i ++) {
            NSMutableArray *subnodes = [NSMutableArray array];
            for (int j = 0; j < height; j ++) {
                [subnodes addObject:[[MazePosition alloc] initWithX:i withY:j]];
            }
            [self.nodes addObject:subnodes];
        }
        
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    
}

@end
