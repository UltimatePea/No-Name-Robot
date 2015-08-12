//
//  SelectLevelScene.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SelectLevelScene : SKScene

- (instancetype)initWithSize:(CGSize)size withChapter:(NSUInteger)chapter;

@property (strong, nonatomic) SKScene *presentingScene;

@end
