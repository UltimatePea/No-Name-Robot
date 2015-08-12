//
//  GameLevelManager.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/28/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Public methods::
 
 + (instancetype)sharedManager;
 
 
 - (void)gameCompletedWithMapSerial:(NSString *)mapSerial;
 
 - (BOOL)isGameLevelAvailableWithMapSerial:(NSString *)mapSerial;

 
 */
@interface GameLevelManager : NSObject

+ (instancetype)sharedManager;


- (void)gameCompletedWithMapSerial:(NSString *)mapSerial;


/**
 If the user can begin this game, returns YES;
 @param mapSerial the serial of the map e.g. 103
 @return YES if user can enter the level
 */
- (BOOL)isGameLevelAvailableWithMapSerial:(NSString *)mapSerial;

@end
