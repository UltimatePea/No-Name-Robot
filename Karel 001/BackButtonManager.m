//
//  BackButtonManager.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "BackButtonManager.h"


@implementation BackButtonManager

+ (void)configureBackButton:(SKSpriteNode *)backButton accordingToScene:(SKScene *)scene
{
    if (backButton == nil) {
        backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back button"];
    }
    backButton.size = CGSizeMake(scene.size.width / 10, scene.size.height / 5);
    backButton.anchorPoint = CGPointMake(0.0, 1.0);
    backButton.position = CGPointMake(0, scene.size.height);
    [scene addChild:backButton];
}

@end
