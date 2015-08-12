//
//  InitialScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

/*'
 
 zPosition
 
 
 
 
 =========10 start button=========
 
 =========0 background=============
 
 
 
 
 
 */




#import "InitialScene.h"
#import "SelectChapterScene.h"

@implementation InitialScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setUpBackground];
    [self setUpStartButton];
    
    
}



- (void)setUpBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"game default background"];
    background.size = self.size;
    background.position = CGPointZero;
    background.anchorPoint = CGPointZero;
    background.zPosition = 0;
    [self addChild:background];
}

#define START_BUTTON_NAME @"start button"

- (void)setUpStartButton
{
    SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:START_BUTTON_NAME];
    startButton.position = CGPointMake(self.size.width/2, self.size.height/2);
    startButton.anchorPoint = CGPointMake(0.5, 0.5);
    startButton.size = CGSizeMake(self.size.width / 5, self.size.width / 5);
    startButton.zPosition = 10;
    startButton.name = START_BUTTON_NAME;
    [self addChild:startButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:START_BUTTON_NAME]) {
        [self startButtonTapped];
    }
    
}

- (void)startButtonTapped
{
    NSLog(@"Start button tapped");
    SelectChapterScene *scene = [[SelectChapterScene alloc] initWithSize:self.size];
    scene.presentingScene = self;
    [self.view presentScene:scene transition:[SKTransition doorsOpenHorizontalWithDuration:1]];
}



@end
