//
//  BackButtonManager.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;

@interface BackButtonManager : NSObject
+ (void)configureBackButton:(SKSpriteNode *)backButton accordingToScene:(SKScene *)scene;
@end
