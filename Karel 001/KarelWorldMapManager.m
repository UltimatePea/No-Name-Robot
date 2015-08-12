//
//  MapManager.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/13/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "KarelWorldMapManager.h"

@interface KarelWorldMapManager ()

@property (weak, nonatomic) NSMutableArray *cachedResult;

@end


@implementation KarelWorldMapManager



- (KarelWorldMap *)mapForSerial:(NSString *)serial
{
    return [[KarelWorldMap alloc] initWithMap:[NSString stringWithFormat:@"Map%@", serial]];
}


static KarelWorldMapManager *sharedManager = nil;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceMapManager;
    
    dispatch_once(&onceMapManager, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSArray *)supportedSerials
{
    
    if (self.cachedResult) {
        return self.cachedResult;
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (int i = 100; i < 999; i ++) {
        if ([[KarelWorldMap alloc] initWithMap:[NSString stringWithFormat:@"%d", i]]) {
            [result addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    self.cachedResult = result;
    return [self supportedSerials];
#warning not efficient, and using recursive will cause potential bugs.
   
}

@end
