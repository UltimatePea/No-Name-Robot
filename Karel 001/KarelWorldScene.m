//
//  KarelWorldScene.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "KarelWorldScene.h"
#import "KarelWorldMap.h"
#import "ProgramExecuter.h"
#import "Compiler.h"
#import "BackButtonManager.h"
#import "GameLevelManager.h"
/*
 This class takes care of the World Scene.
 In its init method, it provides a karel world map configuration, whose width and height is used to init the Karel World instance
 @see in the class's setup private method.
 */

@interface KarelWorldScene () <ProgramExecuterDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Karel *karelModel;
@property (strong, nonatomic) KarelWorldMap *karelWorldMap;
@property (strong, nonatomic) SKSpriteNode *karelNode;
@property (strong, nonatomic) ProgramExecuter *executer;

//@property (strong, nonatomic) SKSpriteNode *backButton;

@end

#define ANIMATION_TIME_INTERVAL  0.3
@implementation KarelWorldScene

#pragma mark - lazy instantiation

- (ProgramExecuter *)executer
{
    if (!_executer) {
        _executer = [[ProgramExecuter alloc]initWithDelegate:self
                                              statementBlock:[Compiler sharedCompiler].statementBlock
                                                   withSpeed:ANIMATION_TIME_INTERVAL];
    }
    return _executer;
}



#pragma mark - constants

- (CGFloat)horizontalSectionWidth
{
    CGFloat hor = self.size.width / (self.karelWorldMap.width + 2);
    CGFloat ver = self.size.height / (self.karelWorldMap.height + 2);
    return (hor > ver)?  ver: hor;
}

- (CGFloat)verticalSectionHeight
{
    return [self horizontalSectionWidth];
    
}

- (CGFloat)absoluteCenterPositionXWithRelativePosition:(Position *)position withOffset:(CGFloat)offset
{
    return (position.xCoordinate + 1.5 + offset) * [self horizontalSectionWidth];
}

- (CGFloat)absoluteCenterPositionYWithRelativePosition:(Position *)position withOffset:(CGFloat)offset
{
    return (position.yCoordinate + 1.5 + offset) * [self verticalSectionHeight];
}

#pragma mark - init and setup

- (instancetype)initWithSize:(CGSize)size withKarelWorldMap:(KarelWorldMap *)map;
{
    self = [super init];
    if (!map){map = [[KarelWorldMap alloc] initWithMap:@"Map101"];}
    if (self) {
        self.size = size;
        self.karelWorldMap = map;
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    //self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
    [self setupModel];
    [self setupBackground];
    
    [self setupWalls];
    [self setupBeepers];
    [self setupKarel];
    [self setupDestinationIndicator];
    [self setupBeepersDestination];
    
    [self setupButtons];
}

- (void)setupModel
{
    self.karelModel = [[Karel alloc] initWithPosition:[[Position alloc] initWithX:self.karelWorldMap.initialPosition .xCoordinate withY:self.karelWorldMap.initialPosition .yCoordinate] withInitialDirection:DirectionEast];
 
}

- (void)setupBackground
{
    /*
    SKSpriteNode *backgroundImg = [SKSpriteNode spriteNodeWithImageNamed:@"background square"];
    backgroundImg.size = CGSizeMake(self.karelWorldMap.width * [self horizontalSectionWidth], self.karelWorldMap.height * [self verticalSectionHeight]);
    backgroundImg.position = CGPointMake([self horizontalSectionWidth], [self verticalSectionHeight]);
    backgroundImg.anchorPoint = CGPointZero;
    backgroundImg.zPosition = 0;
    [self addChild:backgroundImg];
    */
    for (int i = 0; i < self.karelWorldMap.width; i++) {
        for (int j = 0; j < self.karelWorldMap.height; j++) {
           
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"karelBackground"];
            background.size = CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight] );
           // background.position = CGPointMake((i+1) * ([self horizontalSectionWidth]), (j + 1) * ([self verticalSectionHeight]));
            Position *pos  = [[Position alloc] initWithX:i withY:j];

            background.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:pos withOffset: 0], [self absoluteCenterPositionYWithRelativePosition:pos withOffset:0]);
          //  background.anchorPoint = CGPointZero;
            background.zPosition = 10;
            [self addChild:background];
        }
    }
    
    
}
#define KAREL @"karel"
- (void)setupKarel
{
    self.karelNode = [SKSpriteNode spriteNodeWithImageNamed:@"karel"];
    self.karelNode.size = CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
    self.karelNode.name = KAREL;
    [self updateKarelPositionSolelyWithTimeInterval:0 withSender:nil];
    self.karelNode.zPosition = 40;
    [self addChild:self.karelNode];
}

- (void)setupBeepers
{
    [self updateBeepers];
}

- (void)setupDestinationIndicator
{
    SKSpriteNode *destination = [SKSpriteNode spriteNodeWithImageNamed:@"flag" ];
    destination.size = CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
    destination.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:self.karelWorldMap.finalDestination withOffset:0], [self absoluteCenterPositionYWithRelativePosition:self.karelWorldMap.finalDestination withOffset:0]);
    destination.zPosition = 31;
    [self addChild:destination];
    
}

- (void)setupBeepersDestination
{
#warning redundant code with update beeper
    [self.karelWorldMap.finalBeepers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Beeper *beeper = (Beeper *)obj;
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"beeper destination"];
        node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:beeper.position withOffset:0], [self absoluteCenterPositionYWithRelativePosition:beeper.position withOffset:0]);
        node.size = CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
        node.name = @"final beeper";
        node.zPosition = 18;
        [self addChild:node];
    }];
}

#define OFFSET 3
/*
 east --> 1 --> x + 0.5
 south --> 2 ---> y - 0.5
 west --> 3 ---> x - 0.5
 north --> 4 --> y + 0.5
 
 
 */

- (void)setupWalls
{
    [self.karelWorldMap.walls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        KarelWorldWall *wall = (KarelWorldWall *)obj;
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"black"];
       
        if (wall.direction == DirectionNorth||wall.direction == DirectionSouth) {
            node.size = CGSizeMake([self horizontalSectionWidth]+ 2 * OFFSET, OFFSET);
            
            if (wall.direction == DirectionNorth) {
                node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:wall.position withOffset:0], [self absoluteCenterPositionYWithRelativePosition:wall.position withOffset:0.5]);
            } else {
                node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:wall.position withOffset:0], [self absoluteCenterPositionYWithRelativePosition:wall.position withOffset:-0.5]);
            }
        } else { //if (wall.direction == DirectionEast || wall.direction == DirectionWest)
            node.size = CGSizeMake(OFFSET, [self verticalSectionHeight] + 2 * OFFSET);
           
            
            if (wall.direction == DirectionEast) {
               node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:wall.position withOffset:0.5], [self absoluteCenterPositionYWithRelativePosition:wall.position withOffset:0]);
                
                
            } else {
                node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:wall.position withOffset:-0.5], [self absoluteCenterPositionYWithRelativePosition:wall.position withOffset:0]);
            }
        }
        node.zPosition = 30;
        [self addChild:node];
        
    }];
}

- (void)setupButtons
{
    
    //[BackButtonManager configureBackButton:self.backButton accordingToScene:self];
    
    
}

#pragma mark - update methods

- (void)updateKarelPositionSolelyWithTimeInterval:(NSTimeInterval)interval withSender:(id)sender
{
   // SKAction *action = [SKAction moveTo:CGPointMake((self.karelModel.position.xCoordinate + 1.5) * [self horizontalSectionWidth], (self.karelModel.position.yCoordinate + 1.5) * [self verticalSectionHeight]) duration:interval];
    SKAction *action = [SKAction moveTo:CGPointMake([self absoluteCenterPositionXWithRelativePosition:self.karelModel.position withOffset:0], [self absoluteCenterPositionYWithRelativePosition:self.karelModel.position withOffset:0]) duration:interval];
    [self.karelNode runAction:action completion:^{
        [self finishAnimation:sender];
    }];
}

- (void)updateBeepers
{
    __block NSMutableArray *childNodes = [[NSMutableArray alloc] init];
    [self enumerateChildNodesWithName:@"beeper" usingBlock:^(SKNode *node, BOOL *stop) {
        [childNodes addObject:node];
    }];
    [self removeChildrenInArray:childNodes];
    
    [self.karelWorldMap.beepers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Beeper *beeper = (Beeper *)obj;
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"beeper"];
        node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:beeper.position withOffset:0], [self absoluteCenterPositionYWithRelativePosition:beeper.position withOffset:0]);
        node.size = CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
        node.name = @"beeper";
        node.zPosition = 20;
        [self addChild:node];
    }];
}

#pragma mark - setup gesture recognizers
/*
- (void)didMoveToView:(SKView *)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    
    
    
}
*/
#pragma mark - protocol

- (BOOL)isKarelFrontBlocked
{
    Position *position = [[Position alloc] initWithX:self.karelModel.position.xCoordinate withY:self.karelModel.position.yCoordinate];
   return [self.karelWorldMap isWallPresented:[[KarelWorldWall alloc] initWithPosition:position  withDirection:self.karelModel.direction]];
}

- (BOOL)isKarelFrontClear
{
    return ![self isKarelFrontBlocked];
}
#define EXIT @"Exit"
- (void)karelMove:(id<ProgramExecuterProtocol>)sender
{
    if ([self isKarelFrontClear]) {
        SKAction *playSound = [SKAction playSoundFileNamed:@"Karel Move 01.mp3" waitForCompletion:YES];
        [self runAction:playSound];
        [self.karelModel move];
        [self updateKarelPositionSolelyWithTimeInterval:ANIMATION_TIME_INTERVAL withSender:sender];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Front is Blocked" message:@"The robot's front is blocked. Sadly, it's dead."  delegate:self cancelButtonTitle:EXIT otherButtonTitles:nil, nil] show];
    }
    
}

- (void)karelTurnLeft:(id<ProgramExecuterProtocol>)sender
{
    [self.karelModel turnLeft];
    SKAction *action = [SKAction rotateByAngle:M_PI / 2 duration:ANIMATION_TIME_INTERVAL];
    [self.karelNode runAction:action completion:^{
        [self finishAnimation:sender];
    }];
}

- (void)karelPickBeeper:(id<ProgramExecuterProtocol>)sender
{
    [self.karelWorldMap.beepers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Beeper *beeper = (Beeper *)obj;
        if ([beeper.position isEqualToPosition:self.karelModel.position]) {
            [self.karelWorldMap.beepers removeObject:beeper];
            [self updateBeepers];
            BOOL shouldStop = YES;
            stop = &(shouldStop);
        }
    }];
    [sender start];
}

- (void)karelPutBeeper:(id<ProgramExecuterProtocol>)sender
{
    [self.karelWorldMap.beepers addObject:[[Beeper alloc] initWithPosition:self.karelModel.position]];
    [self updateBeepers];
    [sender start];
}

#define KAREL_HAS_COMPLETED_HIS_JOB @"Karel has completed his job."

- (void)programEnded
{
    if ([self.karelModel.position isEqualToPosition:self.karelWorldMap.finalDestination]) {
        if ([self.karelWorldMap isBeepersMovedToSatisfiedPosition]) {
            [self showCompleteAlert];
            
            return;
        }
        
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"The robot has finished executing the program but is unable to finish the task" delegate:self cancelButtonTitle:EXIT otherButtonTitles:nil, nil] show];
    
    
}

- (void)programEncounteredAnError:(NSString *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Sorry" message:[NSString stringWithFormat:@"The program encountered an error and cannot proceed. \r\nError Message: \r\n%@", error] delegate:self cancelButtonTitle:EXIT otherButtonTitles:nil, nil] show];
    
}

- (void)showCompleteAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Well Done" message:KAREL_HAS_COMPLETED_HIS_JOB delegate:self cancelButtonTitle:EXIT otherButtonTitles:nil, nil] show];
    [[GameLevelManager sharedManager] gameCompletedWithMapSerial:self.karelWorldMap.mapSerial];
}

- (void)clear
{
    self.executer = nil;
    self.karelModel = nil;
    self.karelNode = nil;
    [self.karelWorldMap reload];
    [self removeAllChildren];
    [self setup];
}

- (void)finishAnimation:(id)sender
{
#warning redundant code
    if ([self.karelModel.position isEqualToPosition:self.karelWorldMap.finalDestination]) {
        if ([self.karelWorldMap isBeepersMovedToSatisfiedPosition]) {
            
            [self showCompleteAlert];
            
            return;
        }
        
    }
    
    if (_executer) {
        [(ProgramExecuter *)sender start];
        NSLog(@"finished animation, go on %@", sender);
    }
}

#pragma mark - delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (/*buttonIndex == alertView.cancelButtonIndex && */[[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:EXIT]) {
        [self clear];
        [self.presentingVC dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        //CGPoint point = [touch locationInNode:self];
        //SKNode *node = [self nodeAtPoint:point];
        
            if (![self.executer isStarted]) {
                [self.executer start];
            }
        
    }
}



@end
