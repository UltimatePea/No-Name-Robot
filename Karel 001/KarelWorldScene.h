//
//  KarelWorldScene.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "KarelWorldMap.h"
@interface KarelWorldScene : SKSpriteNode

@property (weak, nonatomic) UIViewController *presentingVC;
- (instancetype)initWithSize:(CGSize)size withKarelWorldMap:(KarelWorldMap *)map;


//@property (strong, nonatomic) SKScene *presentingScene;


@end
