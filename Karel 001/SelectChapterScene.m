//
//  SelectChapterScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/16/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

/*
 
 zPosition
 
 
 10: Foreground
 0: Background
 
 
 
 
 
 
 */

#import "SelectChapterScene.h"
#import "SelectLevelScene.h"
#import "BackButtonManager.h"

@interface SelectChapterScene ()

@property (strong, nonatomic) SKSpriteNode *sceneImageNode, *leftArrow, *rightArrow, *startButton, *backButton;
@property (nonatomic) NSUInteger currentSelectedChapter;



@end

@implementation SelectChapterScene

#pragma mark - lazy instantiation

- (SKSpriteNode *)sceneImageNode
{
    if (!_sceneImageNode) {
        _sceneImageNode = [SKSpriteNode spriteNodeWithImageNamed:@"chapter 1"];
        
    }
    return _sceneImageNode;
}


- (SKSpriteNode *)leftArrow
{
    if (!_leftArrow) {
        _leftArrow = [SKSpriteNode spriteNodeWithImageNamed:@"left arrow"];
    }
    return _leftArrow;
}

- (SKSpriteNode *)rightArrow
{
    if (!_rightArrow) {
        _rightArrow = [SKSpriteNode spriteNodeWithImageNamed:@"right arrow"];
    }
    return _rightArrow;
}

- (SKSpriteNode *)startButton
{
    if (!_startButton) {
        _startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start button with label"];
    }
    return _startButton;
}

- (SKSpriteNode *)backButton
{
    if (!_backButton) {
        _backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back button"];
    }
    return _backButton;
}

- (void)setCurrentSelectedChapter:(NSUInteger)currentSelectedChapter
{
    if (currentSelectedChapter > 0 && currentSelectedChapter <= [self numberOfChapters]) {
        _currentSelectedChapter = currentSelectedChapter;
        SKTexture *targetTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"chapter 0%lu", (unsigned long)currentSelectedChapter]];
        self.sceneImageNode.texture = targetTexture;
        [self updateArrowStatus];
    }
    
}

#pragma mark - constants

- (NSUInteger)numberOfChapters
{
    return 2;
}

- (CGSize)squareSizeWithSizeGiven:(CGSize)size withProportion:(CGFloat)proportion
{
    CGFloat sectionWidth;
    if (size.width > size.height) {
        sectionWidth = size.height / proportion;
    } else {
        sectionWidth = size.width / proportion;
    }
    return CGSizeMake(sectionWidth, sectionWidth);
}

- (CGPoint)centerPointInSize:(CGSize)size
{
    return CGPointMake(size.width / 2, size.height / 2);
}


#pragma mark - init and setup

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
    [self setupBackground];
    [self renderForeground];
    self.currentSelectedChapter = 1;
}

- (void)setupBackground
{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"select chapter scene background"];
    background.zPosition = 0;
    background.size = self.size;
    background.position = CGPointZero;
    background.anchorPoint = CGPointZero;
    [self addChild:background];
}

- (void)renderForeground
{
    //render chapter scene
    self.sceneImageNode.size = [self squareSizeWithSizeGiven:self.size withProportion:2];
    self.sceneImageNode.position = [self centerPointInSize:self.size];
    [self addChild:self.sceneImageNode];
    
    //render arrows;
    
    self.leftArrow.zPosition = 10;
    self.leftArrow.size = [self squareSizeWithSizeGiven:self.size withProportion:10];
    self.leftArrow.position = CGPointMake([self centerPointInSize:self.size].x
                                     - (self.sceneImageNode.size.width / 2)
                                     - self.leftArrow.size.width,
                                     [self centerPointInSize:self.size].y);
    [self addChild:self.leftArrow];
    
    
    self.rightArrow.zPosition = self.leftArrow.zPosition;
    self.rightArrow.size = self.leftArrow.size;
    self.rightArrow.position = CGPointMake(([self centerPointInSize:self.size].x
                                       + ([self centerPointInSize:self.size].x - self.leftArrow.position.x)),
                                      [self centerPointInSize:self.size].y);
    [self addChild:self.rightArrow];
    
    //render start buttons
    self.startButton.zPosition = 10;
    self.startButton.size = CGSizeMake(self.sceneImageNode.size.width, self.leftArrow.size.height);
    self.startButton.position = CGPointMake([self centerPointInSize:self.size].x, [self centerPointInSize:self.size].y
                                            - self.sceneImageNode.size.height / 2
                                            - self.startButton.size.height);
    [self addChild:self.startButton];
    
    //render back button
    [BackButtonManager configureBackButton:self.backButton accordingToScene:self];
    
}

#pragma mark - update methods

- (void)updateArrowStatus
{
    self.leftArrow.hidden = NO;
    self.rightArrow.hidden = NO;
    if (self.currentSelectedChapter == 1) {
        self.leftArrow.hidden = YES;
    }
    if (self.currentSelectedChapter == [self numberOfChapters]) {
        self.rightArrow.hidden = YES;
    }
}

#pragma mark - user interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        if ([node isEqual:self.rightArrow]) {
            self.currentSelectedChapter ++;
        } else if ([node isEqual:self.leftArrow]){
            self.currentSelectedChapter --;
        } else if ([node isEqual:self.startButton]){
            [self enterLevelSelection];
        } else if ([node isEqual:self.backButton]){
            [self.view presentScene:self.presentingScene transition:[SKTransition doorsCloseHorizontalWithDuration:0.5]];
        }
    }
}

#pragma mark - navigation

- (void)enterLevelSelection
{
    SelectLevelScene *selectLevel = [[SelectLevelScene alloc] initWithSize:self.size withChapter:self.currentSelectedChapter];
    SKTransition *present = [SKTransition doorsOpenHorizontalWithDuration:0.5];
    selectLevel.presentingScene = self;
    [self.view presentScene:selectLevel transition:present];
}


@end
