//
//  DetailNodeScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/24/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "DetailNodeScene.h"
#import "CoordinateManager.h"
#import "Compiler.h"
#import "ProgramManager.h"
#import "AdvancedLableNode.h"
#import "StatementWithConditionAndCommand.h"


/*
 zPosition
 
 cross button:10
 
 
 */

@interface DetailNodeScene ()
/**
 The statement used to init this scene
 */
@property (strong, nonatomic) StatementWithConditionAndCommand *statement;
@property (strong, nonatomic) CoordinateManager *coordinateManager;

@property (strong, nonatomic) SKSpriteNode *crossButton, *trashButton, *editProgramButton, *leftArrow, *rightArrow;
@property (strong, nonatomic) AdvancedLableNode  *commandNode, *conditionNode;

@end

@implementation DetailNodeScene

#pragma mark - lazy instantiation

- (SKSpriteNode *)crossButton
{
    if (!_crossButton) {
        _crossButton = [SKSpriteNode spriteNodeWithImageNamed:@"cross button"];
    }
    return _crossButton;
}

- (SKSpriteNode *)trashButton
{
    if (!_trashButton) {
        _trashButton = [SKSpriteNode spriteNodeWithImageNamed:@"trash button"];
    }
    return _trashButton;
}

- (SKSpriteNode *)editProgramButton
{
    if (!_editProgramButton) {
        _editProgramButton = [SKSpriteNode spriteNodeWithImageNamed:@"edit button"];
    }
    return _editProgramButton;
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

- (AdvancedLableNode *)conditionNode
{
    if (!_conditionNode) {
        _conditionNode = [[AdvancedLableNode alloc] initWithImageNamed:@"black" withString:self.statement.condition];
    }
    return _conditionNode;
}

- (AdvancedLableNode *)commandNode
{
    if (!_commandNode) {
        _commandNode = [[AdvancedLableNode alloc] initWithImageNamed:@"black" withString:self.statement.command];
    }
    return _commandNode;
}





- (CoordinateManager *)coordinateManager
{
    if (!_coordinateManager) {
        _coordinateManager = [[CoordinateManager alloc] initWithSize:self.size withGridWidth:1 withGridHeight:1];
    }
    return _coordinateManager;
}

- (instancetype)initWithStatement:(StatementWithConditionAndCommand *)statement  withSize:(CGSize)size withDelegate:(id<DetailedNodeSceneDelegate>)delegate
{
    self = [super initWithImageNamed:@"detail scene background"];
    if (self) {
        self.size = size;
        self.statement = statement;
        self.delegate = delegate;
       
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    [self setupCoordinateManager];
    [self setupTrashButton];
    [self setupCrossButton];
    if (self.statement.type == StatementTypeBasic||self.statement.type == StatementTypeFunctionCall) {
        return;
    }
    if (self.statement.type == StatementTypeFunction) {
        [self setupEditProgramButtonIfAvailable];
    } else {
        if (self.statement.type == StatementTypeFor) {
            [self setupArrows];
        }
        [self setupConditionNode];
        [self setupCommandNode];
            
        
        
    }
    
    [self setupNotificationReceiver];
    
    
}

- (void)setupCoordinateManager
{
    switch (self.statement.type) {
        case StatementTypeBasic:
            self.coordinateManager.gridHeight = 1;
            self.coordinateManager.gridWidth = 1;
            break;
        case StatementTypeFunctionCall:
            self.coordinateManager.gridHeight = 1;
            self.coordinateManager.gridWidth = 1;
            break;
        case StatementTypeFunction:
            self.coordinateManager.gridWidth = 2;
            self.coordinateManager.gridHeight = 1;
            break;
        case StatementTypeFor:
            self.coordinateManager.gridWidth = 5;
            self.coordinateManager.gridHeight = 1;
            break;
        case StatementTypeIf:
            self.coordinateManager.gridWidth = 3;
            self.coordinateManager.gridHeight = 1;
            break;
        case StatementTypeWhile:
            self.coordinateManager.gridWidth = 3;
            self.coordinateManager.gridHeight = 1;
            break;
        
        default:
            break;
    }
}

- (void)setupTrashButton
{
    
    self.trashButton.size = [self.coordinateManager standardNodeSize];
    self.trashButton.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake((self.coordinateManager.gridWidth - 1), 0)];
    
    [self addChild:self.trashButton];
}

- (void)setupCrossButton
{
    self.crossButton.position = CGPointMake(self.size.width - self.size.width / 2, self.size.height - self.size.height / 2);
    self.crossButton.size = CGSizeMake([self.coordinateManager horizontalSectionWidth] / 2 , [self.coordinateManager verticalSectionHeight] );
    self.crossButton.zPosition = 10;
    [self addChild:self.crossButton];
    
}

- (void)setupArrows
{
    if (self.statement.type == StatementTypeFor) {
        self.leftArrow.size = self.coordinateManager.standardNodeSize;
        self.leftArrow.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake(0, 0)];
        [self addChild:self.leftArrow];
        
        self.rightArrow.size = self.leftArrow.size;
        self.rightArrow.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake(2, 0)];
        [self addChild:self.rightArrow];
    }
}

- (void)setupConditionNode
{
    self.conditionNode.size = [self.coordinateManager standardNodeSize];
    self.conditionNode.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:
                                   CGPointMake((self.statement.type == StatementTypeFor? 1:0), 0)];
    [self addChild:self.conditionNode];
}

- (void)setupCommandNode
{
    self.commandNode.size = [self.coordinateManager standardNodeSize];
    [self addChild:self.commandNode];
    
    self.commandNode.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointMake([self.coordinateManager gridWidth] - 2, 0)];
}

- (void)setupNotificationReceiver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:NOTIFICATION_STATEMENT_CONDITION_CHANGED object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateCondition];
    }];
    [center addObserverForName:NOTIFICATION_STATEMENT_COMMAND_CHANGED object:nil queue:nil usingBlock:^(NSNotification *note) {
        [self updateCommand];
    }];
}

#pragma mark - update methods

- (void)update
{
    [self updateCondition];
    [self updateCommand];
}
/**
 Updates condition node's display
 */
- (void)updateCondition
{
    @try {
        self.conditionNode.label = self.statement.condition;
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
    
}

- (void)updateCommand
{
    self.commandNode.label = self.statement.command;
}
/**
 Setup the edit button where user gonna enter editing the program
 */
- (void)setupEditProgramButtonIfAvailable
{
    if (self.statement.type == StatementTypeFunction) {
        self.editProgramButton.size = [self.coordinateManager standardNodeSize];
        self.editProgramButton.position = [self.coordinateManager absoluteCenterPositionOfNodeOfRelativeCoordinate:CGPointZero];
        [self addChild:self.editProgramButton];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node isEqual:self.crossButton]) {
        
        [self removeFromParent];
        
    } else if([node isEqual:self.trashButton]){
        [self deleteCurrentStatement];
    } else if([node isEqual:self.editProgramButton]){
        if (self.statement.type == StatementTypeFunction) {
            [self loadStatementBlock];
            
        }
    } else if ([node isEqual:self.leftArrow]){
        if(self.statement.type == StatementTypeFor){
            self.statement.condition = [NSString stringWithFormat:@"%ld", [self.statement.condition integerValue] - 1];
        }
        
    } else if ([node isEqual:self.rightArrow]){
        if(self.statement.type == StatementTypeFor){
            self.statement.condition = [NSString stringWithFormat:@"%ld", [self.statement.condition integerValue] + 1];
        }
        
    }
    
}



/**
 Delete current statement
 
 */
- (void)deleteCurrentStatement
{
    StatementType type = self.statement.type;
    if (type == StatementTypeFunction){
        NSArray *names = [[ProgramManager sharedManager].statementBlocks allKeys];
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *name = obj;
            if ([name isEqualToString:self.statement.identifier]) {
                [[ProgramManager sharedManager].statementBlocks removeObjectForKey:name];
                BOOL shouldStop = YES;
                stop = &shouldStop;
            }
        }];
        [self removeFromParent];
        
    } else {
        NSMutableArray *statementBlock = [Compiler sharedCompiler].statementBlock;
        [statementBlock removeObject:self.statement];
        [self removeFromParent];
    }
        
    [self.delegate didDeleteStatement:self.statement];
}

/**
 transfer the array from program manager to program executer
 */
- (void)loadStatementBlock
{
    if (self.statement.type == StatementTypeFunction) {
        NSArray *names = [[ProgramManager sharedManager].statementBlocks allKeys];
        [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = obj;
            if ([key isEqualToString:self.statement.identifier]) {
                NSMutableArray *desiredStatementBlock = [[ProgramManager sharedManager].statementBlocks objectForKey:key];
                [Compiler sharedCompiler].statementBlock = desiredStatementBlock;
                [self.delegate didChangeCompilingStatementBlock:desiredStatementBlock];
                BOOL shouldStop = YES;
                stop = &shouldStop;
            }
        }];
        [self removeFromParent];
    }
}


@end
