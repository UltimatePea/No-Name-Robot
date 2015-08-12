//
//  GameLevelManager.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/28/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameLevelManager.h"

@implementation GameLevelManager

#pragma mark - singleton
static GameLevelManager *sharedManager;

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super alloc] init];
    });
    return sharedManager;
}




#define LEVEL @"LEVEL"

- (void)gameCompletedWithMapSerial:(NSString *)mapSerial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:[mapSerial integerValue] forKey:LEVEL];
    
    
}


- (BOOL)isGameLevelAvailableWithMapSerial:(NSString *)mapSerial
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger levelCompleted = [defaults integerForKey:LEVEL];
    
    if (levelCompleted == 0) {
        [defaults setInteger:10 forKey:LEVEL];
        levelCompleted = 10;
    }
    
    if (levelCompleted + 1 >= [mapSerial integerValue]) {
        return YES;
    }
    if (levelCompleted % 10 == 0) {
        levelCompleted += 91;
    
        if (levelCompleted + 1 <= [mapSerial integerValue]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
