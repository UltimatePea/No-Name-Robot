//
//  KarelWorldAndEditScene.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "KarelWorldScene.h"

@interface KarelWorldAndEditScene : SKScene

@property (strong, nonatomic) SKScene *presentingScene;

- (instancetype)initWithSize:(CGSize)size withKarelWorldScene:(KarelWorldScene *)karelWorldScene;



@end
