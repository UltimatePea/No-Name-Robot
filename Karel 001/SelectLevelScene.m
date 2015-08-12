//
//  SelectLevelScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

/*
 20:labels
 10:nodes levels(only for navigation purpose)
 0:background
 
 
 */

#import "SelectLevelScene.h"
#import "KarelWorldScene.h"
#import "KarelWorldAndEditScene.h"
#import "BackButtonManager.h"
#import "AdvancedLableNode.h"
#import "GameLevelManager.h"



@interface SelectLevelScene ()

@property (nonatomic) NSUInteger chapterNumber;
@property (strong, nonatomic) SKSpriteNode *backButton;


@end

@implementation SelectLevelScene

#pragma mark - lazy instantiaiton

- (SKSpriteNode *)backButton
{
    if (!_backButton) {
        _backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back button"];
    }
    return _backButton;
}

#pragma mark - init and setup

- (instancetype)initWithSize:(CGSize)size withChapter:(NSUInteger)chapter
{
    self = [super initWithSize:size];
    if (self) {
        
        self.chapterNumber = chapter;
       
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [self removeAllChildren];
    [self setup];
}

- (void)setup
{
    
    
    [self setupBackground];
    [self setupForeground];
}

- (void)setupBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"select level scene background"];
    background.zPosition = 0;
    background.size = self.size;
    background.position = CGPointZero;
    background.anchorPoint = CGPointZero;
    [self addChild:background];
}


- (void)setupForeground
{
   // SKTexture *levelTexture = [SKTexture textureWithImageNamed:@"level"];
    for (int i = 1; i < 11; i ++) {
        AdvancedLableNode *node = [[AdvancedLableNode alloc] initWithImageNamed:@"level" withString:nil];
        
        if (i >= 10) {
            node.name = [NSString stringWithFormat:@"%d", i];
        } else {
            node.name = [NSString stringWithFormat:@"0%d", i];
        }
#define LEVEL_NODE_Z_POSITION 10
        node.zPosition = LEVEL_NODE_Z_POSITION;
        node.size = CGSizeMake(self.size.width / 7, self.size.height / 3);
        node.position = [self positionForNodeWithIndex:i];
        [self addChild:node];
        
        GameLevelManager *levelManager = [GameLevelManager sharedManager];
        if ([levelManager isGameLevelAvailableWithMapSerial:[self mapSerialWithNode:node]]) {
            node.label = [NSString stringWithFormat:@"Level %@",node.name];
        } else {
#define LOCKED @"Locked"
            node.label = LOCKED;
        }
        /*
        SKLabelNode *label = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Level %@",node.name]];
        label.zPosition = 20;
        label.position = node.position;
        label.fontSize = 12;
        label.fontColor = [SKColor redColor];
        
        [self addChild:label];
        */
    }
    
    [BackButtonManager configureBackButton:self.backButton accordingToScene:self];
    
}

- (NSString *)mapSerialWithNode:(AdvancedLableNode *)node
{
    return [NSString stringWithFormat:@"%lu%@", (unsigned long)self.chapterNumber, node.name];
}

- (CGPoint)positionForNodeWithIndex:(int)index
{
    CGFloat x;
    CGFloat y;
    if (1 <= index && index <= 5) {
        x = (0.5 / 7) * self.size.width + index * (self.size.width / 7);
        y = self.size.height / 2;
    } else {
        x = (0.5 / 7) * self.size.width + (index - 5) * (self.size.width / 7);
        y = self.size.height / 2 - self.size.height / 3;
    }
    return CGPointMake(x, y);
}

#pragma mark - navigation

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if (node.zPosition == LEVEL_NODE_Z_POSITION) {
#warning potentially problematic use self.size instead of kW&EScene.size
            
            KarelWorldScene *karelWorldScene = [[KarelWorldScene alloc] initWithSize:CGSizeMake(self.size.width / 2, self.size.height) withKarelWorldMap:[[KarelWorldMap alloc] initWithMap:[self mapSerialWithNode:(AdvancedLableNode *)node]]];
            KarelWorldAndEditScene *scene = [[KarelWorldAndEditScene alloc] initWithSize:self.size withKarelWorldScene:karelWorldScene];
            SKTransition *present = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            scene.presentingScene = self;
            [self.view presentScene:scene transition:present];
        } else if ([node isEqual:self.backButton])
        {
            [self.view presentScene:self.presentingScene transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
        }
    }
}

@end
