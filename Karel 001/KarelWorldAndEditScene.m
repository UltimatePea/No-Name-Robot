//
//  KarelWorldAndEditScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//



/*
 
 
 zPosition
 
 
 20:backbutton
 10:scenes
 
 
 
 
 */






#import "KarelWorldAndEditScene.h"
#import "BackButtonManager.h"
#import "EditCommandScene.h"
#import "ProgramManager.h"
#import "Compiler.h"

@interface KarelWorldAndEditScene ()

@property (strong, nonatomic) SKSpriteNode *backButton;
@property (strong, nonatomic) KarelWorldScene *karelWorldScene;
@property (strong, nonatomic) EditCommandScene *editCommandScene;

@property (nonatomic) BOOL soundOn;

@end

@implementation KarelWorldAndEditScene
#pragma mark - public constant


#pragma mark - lazy instantiaiton


- (SKSpriteNode *)backButton
{
    if (!_backButton) {
        _backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back button"];
    }
    return _backButton;
}

- (EditCommandScene *)editCommandScene
{
    if (!_editCommandScene) {
        _editCommandScene = [[EditCommandScene alloc] initWithSize:CGSizeMake( self.size.width / 2, self.size.height)];
    }
    return _editCommandScene;
}

#pragma mark - init and setup

- (instancetype)initWithSize:(CGSize)size withKarelWorldScene:(KarelWorldScene *)karelWorldScene
{
    self = [super initWithSize:size];
    if (self) {
        self.karelWorldScene = karelWorldScene;
        [self setup];
    }
    return self;
}

- (void)setup
{
    [Compiler sharedCompiler].statementBlock = nil;
    [ProgramManager sharedManager].statementBlocks = nil;
    self.backgroundColor = [SKColor whiteColor];
    //self.userInteractionEnabled = YES;
    [self setupButtons];
    [self setupChileScenes];
    
}

- (void)setupChileScenes
{
    // setup Karel World
    self.karelWorldScene.size = CGSizeMake(self.size.width / 2, self.size.height);
    self.karelWorldScene.position = CGPointZero;
    self.karelWorldScene.anchorPoint = CGPointZero;
    [self addChild:self.karelWorldScene];
    
    // setup Edit Scene
    self.editCommandScene.position = CGPointMake(self.size.width/ 2, 0);
    //self.editCommandScene.anchorPoint = CGPointMake(1.0, 0.0);
    [self addChild:self.editCommandScene];
}

- (void)setupButtons
{
    [BackButtonManager configureBackButton:self.backButton accordingToScene:self];
    self.backButton.zPosition = 20;
}



#pragma mark - user interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint point = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:point];
        if ([node isEqual:self.backButton]) {
            NSLog(@"user tapped back button");
            [self.view presentScene:self.presentingScene transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
        } 
    }
    
}
#pragma mark - Sounds
- (void)playSound
{
    if (self.soundOn) {
        return;
    }
    SKAction *playSound = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"backgroundSound.mp3" waitForCompletion:YES]];
    [self runAction:playSound];
    self.soundOn = YES;
}
- (void)didMoveToView:(SKView *)view
{
    [self playSound];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:self queue:nil usingBlock:^(NSNotification *note) {
        [self playSound];
    }];
}


@end
