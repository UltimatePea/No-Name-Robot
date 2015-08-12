//
//  MapManager.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/13/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KarelWorldMap.h"

@interface KarelWorldMapManager : NSObject

- (KarelWorldMap *)mapForSerial:(NSString *)serial;



+ (instancetype)sharedManager;

- (NSArray *)supportedSerials;

@end
