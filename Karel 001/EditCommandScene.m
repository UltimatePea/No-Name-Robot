//
//  EditCommandScene.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

/*
 
 Program    StatementBlock  BasicCommand
    ^           ^               ^       
 [name]     [name]          [name]
  [name]     [name]          [name]
  [name]     [name]          [name]
 [name]     [name]          [name]
    ↓           ⇓               ⇓
 
 3 * 7
 
 starts from (0, 0) from bottom left
 
 
 zPosition
 
 30:title
 22:detail node
 21:arrow indicator
 20:arrows
 10:advanced label nodes
 
 
 
 
 
 
 */

#import "EditCommandScene.h"
#import "AdvancedLableNode.h"
#import "ProgramManager.h"
#import "Compiler.h"
#import "Statement.h"
#import "StatementIdentifier.h"
#import "Arrow.h"
#import "StatementWithConditionAndCommand.h"
#import "DetailNodeScene.h"


typedef enum : NSUInteger {
    RightColumeTypeCommand,
    RightColumeTypeCondition,
} RightColumeType;

struct Location {
    NSInteger xCoordinate;
    NSInteger yCoordinate;
};

@interface EditCommandScene () <ProgramManagerNewProgramProtocol, UIAlertViewDelegate, DetailedNodeSceneDelegate>

//@property (nonatomic) NSArray *pageCounts;//two dimensional array NSARRAY and NsMutableArray
@property (nonatomic) int pageCountColumnOne, pageCountColumnTwo, pageCountColumnThree;
@property (nonatomic) RightColumeType rightColumeType;
@property (strong, nonatomic) NSArray *spriteGrid, *arrowGrid;
@property (strong, nonatomic) NSMutableArray *titleNodes;

@property (strong, nonatomic) AdvancedLableNode *nodeBeingDragged, *nodeBeingTapped, *linesOfCodeNode;

@property (strong, nonatomic) Arrow *arrowIndicator;



@end


@implementation EditCommandScene

#pragma mark - lazy instantiation

/*
- (NSArray *)pageCounts
{
    if (!_pageCounts) {
        _pageCounts = [NSArray arrayWithObjects:[NSNumber numberWithInt:0],
                       [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
    }
    return _pageCounts;
}
 */

- (NSArray *)spriteGrid
{
    if (!_spriteGrid) {
        _spriteGrid = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    }
    return _spriteGrid;
}

- (NSArray *)arrowGrid
{
    if (!_arrowGrid) {
        _arrowGrid = [NSArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    }
    return _arrowGrid;
}

- (NSMutableArray *)titleNodes
{
    if (!_titleNodes) {
        _titleNodes = [NSMutableArray array];
    }
    return _titleNodes;
}

- (Arrow *)arrowIndicator
{
    if (!_arrowIndicator) {
        _arrowIndicator = [[Arrow alloc] init];
        _arrowIndicator.position = CGPointMake(self.size.width, self.size.height / 2);
        [self addChild:_arrowIndicator];
        _arrowIndicator.zPosition = 21;
    }
    return _arrowIndicator;
}

- (AdvancedLableNode *)linesOfCodeNode
{
    if (!_linesOfCodeNode) {
        _linesOfCodeNode = [[AdvancedLableNode alloc] initWithImageNamed:@"black" withString:nil];
    }
    return _linesOfCodeNode;
}


#pragma mark - constants
#warning redundant code with Karel World Scene

- (NSInteger)gridWidth
{
    return 3;
}

- (NSInteger)gridHeight
{
    return 7;
}

- (CGFloat)horizontalSectionWidth
{
    return self.size.width / [self gridWidth];
}

- (CGFloat)verticalSectionHeight
{
    return self.size.height / [self gridHeight];
    
}

- (CGFloat)absoluteCenterPositionXWithRelativePosition:(CGFloat)xCoordinate withOffset:(CGFloat)offset
{
    return (xCoordinate + .5 + offset) * [self horizontalSectionWidth];
}

- (CGFloat)absoluteCenterPositionYWithRelativePosition:(CGFloat)yCoordinate withOffset:(CGFloat)offset
{
    return (yCoordinate + .5 + offset) * [self verticalSectionHeight];
}

- (NSArray *)titles
{
    return @[@"Task(Add)", @"List", (self.rightColumeType == RightColumeTypeCommand)? @"Commmand" : @"Condition"];
}

- (CGSize)standardNodeSize
{
    return CGSizeMake([self horizontalSectionWidth], [self verticalSectionHeight]);
}

- (NSUInteger)numberOfRowsPerPage
{
    return [self gridHeight] - 3;
}

#pragma mark - init and setup

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.size = size;
        [self setup];
    }
    return self;
}



- (void)setup
{
    //self.zPosition = 0;
    self.userInteractionEnabled = YES;
    self.rightColumeType = RightColumeTypeCommand;
    [self setupTitle];
    [self setupArrows];
    [self setupSpriteGrid];
    [self setupLinesOfCodeNode];
}

- (void)setupTitle
{
    for (int i = 0; i < 3; i ++) {
        AdvancedLableNode *node = [[AdvancedLableNode alloc] initWithImageNamed:@"black" withString:[[self titles] objectAtIndex:i]];
        node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:i withOffset:0], [self absoluteCenterPositionYWithRelativePosition:[self gridHeight] -1 withOffset:0]);
        node.size = [self standardNodeSize];
#define TITLE_NODE_NAME @"TITLE_NODE_NAME"
        node.name = TITLE_NODE_NAME;
        node.zPosition = 30;
        [self addChild:node];
        [self.titleNodes addObject:node];
    }
}

- (void)setupArrows
{
    
    for (int i = 0; i < 3; i ++) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"up arrow"];
        node.size = [self standardNodeSize];
        node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:i withOffset:0], [self absoluteCenterPositionYWithRelativePosition:[self gridHeight] - 2 withOffset:0]);
        node.zPosition = 20;
        node.name = [NSString stringWithFormat:@"%dup", i];
        [self addChild:node];
        [[self.arrowGrid objectAtIndex:i] addObject:node];
    }
    
    for (int i = 0; i < 3; i ++) {
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"down arrow"];
        node.size = [self standardNodeSize];
        node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:i withOffset:0], [self absoluteCenterPositionYWithRelativePosition:0 withOffset:0] );
        node.zPosition = 20;
        node.name = [NSString stringWithFormat:@"%ddown", i];
        [self addChild:node];
        [[self.arrowGrid objectAtIndex:i] addObject:node];
    }
    
}

- (void)setupSpriteGrid
{
    for (int i = 0; i < 3; i ++) {
        for (int j = 4; j > 0; j --) {
            AdvancedLableNode *node = [[AdvancedLableNode alloc] initWithImageNamed:@"sprite background" withString:nil];
            node.size = [self standardNodeSize];
            node.position = CGPointMake([self absoluteCenterPositionXWithRelativePosition:i withOffset:0], [self absoluteCenterPositionYWithRelativePosition:j withOffset:0]);
            node.zPosition = 10;
#define ADVANCED_NODE_NAME_UNIFORMED @"ADVANCED_NODE_NAME_UNIFORMED"
            node.name = ADVANCED_NODE_NAME_UNIFORMED;
            [self addChild:node];
            [(NSMutableArray *)[self.spriteGrid objectAtIndex:i] addObject:node];
        }
    }
    [self updateSpriteGrid];
    
}

- (void)setupLinesOfCodeNode
{
    self.linesOfCodeNode.position = CGPointZero;
    self.linesOfCodeNode.size = CGSizeMake([self verticalSectionHeight], [self verticalSectionHeight] );
    self.linesOfCodeNode.anchorPoint = CGPointZero;
    [self addChild:self.linesOfCodeNode];
}




#pragma mark - update methods



- (void)update
{
    [self updatePageCount];
    [self updateTitles];
    [self updateSpriteGrid];
    [self updateLinesOfCodeNode];
}

- (void)updatePageCount
{
    self.pageCountColumnTwo = (int)([[Compiler sharedCompiler].statementBlock count] / [self numberOfRowsPerPage]);
    if (self.rightColumeType == RightColumeTypeCondition) {
        self.pageCountColumnThree = 0;
    }
}

- (void)updateTitles
{
    [self.titleNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AdvancedLableNode *node = obj;
        node.label = [[self titles] objectAtIndex:idx];
    }];
}

- (void)updateSpriteGrid
{
    [self updateTheFirstColumn];
    [self updateTheSecondColumn];
    [self updateTheThirdColumn];
    [self updateArrows];
    
    
}

- (void)updateTheFirstColumn
{
    ProgramManager *manager = [ProgramManager sharedManager];
    NSMutableArray *firstColume = [self.spriteGrid objectAtIndex:0];
    
    
    //update the first colume
    if ([[manager.statementBlocks allKeys] count] == 0) {
        [firstColume enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AdvancedLableNode *node = obj;
            node.label = nil;
        }];
        return;
    }
    
    [firstColume enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        AdvancedLableNode *node = obj;
        NSUInteger desiredIndexOfKey = idx + [self numberOfRowsPerPage] * self.pageCountColumnOne;
        
        if (!([[manager.statementBlocks allKeys] count] -1 < desiredIndexOfKey) ) {
            
                node.label = [[manager.statementBlocks allKeys] objectAtIndex:desiredIndexOfKey];
            
            
        } else {
            node.label = nil;
        }
        
    }];
}

- (void)updateTheSecondColumn
{
    Compiler *compiler = [Compiler sharedCompiler];
    NSMutableArray *secondColumn = [self.spriteGrid objectAtIndex:1];
    
    if([compiler.statementBlock count] == 0){
        [secondColumn enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AdvancedLableNode *node = obj;
            node.label = nil;
        }];
        
        return;
    
    }
    
    [secondColumn enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AdvancedLableNode *node = obj;
        NSUInteger desiredIndexOfStatement = idx + [self numberOfRowsPerPage] * self.pageCountColumnTwo;
        if (desiredIndexOfStatement <= [compiler.statementBlock count] - 1) {
            Statement *statement = [compiler.statementBlock objectAtIndex:desiredIndexOfStatement];
            node.label = statement.identifier;
        } else {
            node.label = nil;
        }
    }];
}

- (void)updateTheThirdColumn
{
    NSArray *supportedIdentifiers = self.rightColumeType==RightColumeTypeCommand?
    [StatementIdentifier supportedIdentifiers]:[StatementIdentifier supportedIdentifiersOfTypeCondition];
    NSMutableArray *thridColumn = [self.spriteGrid objectAtIndex:2];
    [thridColumn enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AdvancedLableNode *node = obj;
        NSUInteger desiredIndex = idx + [self numberOfRowsPerPage] * self.pageCountColumnThree;
        if (desiredIndex <= [supportedIdentifiers count] - 1) {
            node.label = [supportedIdentifiers objectAtIndex:desiredIndex];
        } else {
            node.label = nil;
        }
    }];
}

- (void)updateArrows
{
    if (self.pageCountColumnOne == 0) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:0] objectAtIndex:0];
        node.hidden = YES;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:0] objectAtIndex:0];
        node.hidden = NO;
    }
    
    if (self.pageCountColumnTwo == 0) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:1] objectAtIndex:0];
        node.hidden = YES;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:1] objectAtIndex:0];
        node.hidden = NO;
    }
    
    if (self.pageCountColumnThree == 0) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:2] objectAtIndex:0];
        node.hidden = YES  ;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:2] objectAtIndex:0];
        node.hidden = NO;
    }
    
    
    
    if ((self.pageCountColumnOne + 1) * [self numberOfRowsPerPage] < [[[ProgramManager sharedManager].statementBlocks allKeys] count]) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:0] objectAtIndex:1];
        node.hidden = NO;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:0] objectAtIndex:1];
        node.hidden = YES;
    }
    
    if ((self.pageCountColumnTwo + 1) * [self numberOfRowsPerPage] <= [[Compiler sharedCompiler].statementBlock count]) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:1] objectAtIndex:1];
        node.hidden = NO;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:1] objectAtIndex:1];
        node.hidden = YES;
    }
    
    if ((self.pageCountColumnThree + 1) * [self numberOfRowsPerPage] < (self.rightColumeType==RightColumeTypeCommand?[[StatementIdentifier supportedIdentifiers] count]:[[StatementIdentifier supportedIdentifiersOfTypeCondition] count])) {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:2] objectAtIndex:1];
        node.hidden = NO;
    } else {
        SKSpriteNode  *node = [[self.arrowGrid objectAtIndex:2] objectAtIndex:1];
        node.hidden = YES;
    }
    
    
    
    
}

- (void)updateLinesOfCodeNode
{
    self.linesOfCodeNode.label = [NSString stringWithFormat:@"%ld", [[ProgramManager sharedManager] linesOfCode]];
}

#pragma mark - user interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    //NSLog(@"Touches in initial Node: X: %f Y: %f", location.x, location.y);
    
    //if it is title
    if ([node.name isEqualToString: TITLE_NODE_NAME]) {
        NSUInteger index = [self.titleNodes indexOfObject:node];
        switch (index) {
            case 0:
                [[ProgramManager sharedManager] newProgram:self];
                break;
                
            case 2:
                self.rightColumeType = (self.rightColumeType==RightColumeTypeCommand)?RightColumeTypeCondition:RightColumeTypeCommand;
                [self update];
            default:
                break;
        }
    }
    
    //if the node belongs to the sprite grid, then listen action on it
    
    if (!([self indexOfColumnInSpriteGridwithPosition:location] == -1)) {
        self.nodeBeingDragged = [self spriteGridNodeAtPosition:location];
    }
    
    
    //if it is not in list then drag
#warning potential problems of dragging arrows (fixed), redundant code
    if (([self indexOfColumnInSpriteGridwithPosition:location] == 0)||([self indexOfColumnInSpriteGridwithPosition:location] == 2)) {
        AdvancedLableNode *node = [self spriteGridNodeAtPosition:location];
        self.nodeBeingDragged = node;
        
        [self.arrowIndicator didStartMoveAtPoint:node.position];
    }
    
    //check if it's arrow
    
    if ([node isMemberOfClass:[SKSpriteNode class]]&&(!(node.isHidden))) {
        if ([node.name isEqualToString:@"0up"]) {
            self.pageCountColumnOne--;
        } else if ([node.name isEqualToString:@"0down"]){
            self.pageCountColumnOne++;
        } else if ([node.name isEqualToString:@"1up"]){
            self.pageCountColumnTwo--;
        } else if ([node.name isEqualToString:@"1down"]){
            self.pageCountColumnTwo++;
        } else if ([node.name isEqualToString:@"2up"]){
            self.pageCountColumnThree--;
        } else if ([node.name isEqualToString:@"2down"]){
            self.pageCountColumnThree++;
        }
        [self updateSpriteGrid];
        //NSLog(@"Arrow, tapped");
    }
    //NSLog(@"the node detected is %@", node);
    
    
    //NSLog(@"Node being touched: %@", node);
    
    /*
    if ([node isKindOfClass:[AdvancedLableNode class]]) {
        self.nodeBeingDragged = node;
        [self.arrowIndicator didStartMoveAtPoint:self.nodeBeingDragged.position];
    } else if ([node isKindOfClass:[SKLabelNode class]])
    {
        if (![node.parent.name isEqualToString:TITLE_NODE_NAME]) {
            self.nodeBeingDragged = node.parent;
            [self.arrowIndicator didStartMoveAtPoint:self.nodeBeingDragged.position];
        }
        
    }*/
    //NSLog(@"touches began");
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    /*
    //if(!self.nodeBeingDragged) self.nodeBeingDragged = [self nodeAtPoint:location];
    self.nodeBeingDragged.position = location;
    NSLog(@"%@", self.nodeBeingDragged);
     */
    if (self.nodeBeingDragged == nil) {
        return;
    }
    [self.arrowIndicator didMoveToPosition:[self spriteGridNodeAtPosition:location].position];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
   
    
    [self.arrowIndicator didEndMoveAtPoint:location];
    if (self.nodeBeingDragged == nil) {
        return;
    }
    //show detail
    if ([self.nodeBeingDragged isEqual:[self spriteGridNodeAtPosition:location]]) {
        if ([self isPositionBelongToListAkaSecondColumn:location]) {
            [self userDidTapNodeInSpriteGrid:self.nodeBeingDragged inColumn:2];
        } else if ([self indexOfColumnInSpriteGridwithPosition:location] == 0){
            [self userDidTapNodeInSpriteGrid:self.nodeBeingDragged inColumn:1];
        }
        
    }
    
    
    if ([self isPositionBelongToListAkaSecondColumn:location]) {
        AdvancedLableNode *node = [self spriteGridNodeAtPosition:location];
        if (node.label == nil) {
#warning Always insert after the statement block, if changed to isert, change the alertview delegate
            
            
            if ([self.nodeBeingDragged.label isEqualToString:@"for"]) {
#define FOR_QUERY_TITLE @"For"
#define OK @"OK"
#define CANCEL @"Cancel"
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:FOR_QUERY_TITLE message:@"How many times would you like to execute the statement" delegate:self cancelButtonTitle:CANCEL otherButtonTitles:OK, nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
                [alertView show];
                
            } else {//if currrently the node is [OMIT] and the node being dragged is not
                if(self.nodeBeingDragged.label != nil){
                [[Compiler sharedCompiler].statementBlock addObject:[[StatementWithConditionAndCommand alloc] initWithIdentifier:self.nodeBeingDragged.label]];
                }
            }
        } else if ([node.label isEqualToString: @"while"] || [node.label isEqualToString:@"for"] || [node.label isEqualToString:@"if"] ) {
            struct Location indexPathForNode = [self indexPathForSpriteGridNode:node];
            if ([self.nodeBeingDragged.label isEqualToString:@"while"]||[self.nodeBeingDragged.label isEqualToString:@"for"]||[self.nodeBeingDragged.label isEqualToString:@"if"]) {
                
            } else {
                StatementWithConditionAndCommand *statement = [[Compiler sharedCompiler].statementBlock objectAtIndex:[self indexOfArrayFormRelativeIndex:indexPathForNode.yCoordinate withPageCount:self.pageCountColumnTwo]];
                if ([StatementIdentifier isIdentifierConditionFamily:self.nodeBeingDragged.label]&&(![self.nodeBeingDragged.label isEqualToString:@"for"])) {
                    statement.condition = self.nodeBeingDragged.label;
                } else {
                    statement.command = self.nodeBeingDragged.label;
                }
                
            }
        }
        
        [self update];
    }
     self.nodeBeingDragged = nil;
}

#warning bugs of callers
/**
 *column number specified from 1
 */
- (void)userDidTapNodeInSpriteGrid:(AdvancedLableNode *)node inColumn:(NSInteger)column
{
    if (([[Compiler sharedCompiler].statementBlock count] == 0)&&(column == 2)) {
        return;
    }
    if (node.label == nil) {
        return;
    }
    
#warning AT Feb. 4, I changed the type statement to statement with C and C, to fix a issue. \r\n without other modification\r\n may cause bugs
    
    StatementWithConditionAndCommand *statement;
    DetailNodeScene *detail;
    
    switch (column) {
        case 1:
            statement = [[StatementWithConditionAndCommand alloc]
                         initWithIdentifier:[[ProgramManager sharedManager].statementBlocks.allKeys
                                             objectAtIndex:
                                             [self indexOfArrayFormRelativeIndex:[self indexPathForSpriteGridNode:node].yCoordinate withPageCount:self.pageCountColumnOne]] withType:StatementTypeFunction];
                                             
            
            break;
        case 2:
            statement = [[Compiler sharedCompiler].statementBlock objectAtIndex:[self indexOfArrayFormRelativeIndex:[self indexPathForSpriteGridNode:node].yCoordinate withPageCount:self.pageCountColumnTwo]];
            
            
            break;
            
        default:
            break;
    }
    detail = [[DetailNodeScene alloc] initWithStatement:statement withSize:CGSizeMake([self horizontalSectionWidth] * 2, [self verticalSectionHeight]) withDelegate:self];
    
    detail.position = node.position;
    detail.zPosition = 22;
    [self addChild:detail];
    
    
}

#pragma mark - converting coordinates

- (struct Location)indexPathForSpriteGridNode:(AdvancedLableNode *)node//starts from top left at 0, 0
{
    __block struct Location path;
    [self.spriteGrid enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableArray *array = obj;
        NSUInteger column = idx;
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:node]) {
                NSUInteger row = idx;
                
                path.xCoordinate = column;
                path.yCoordinate = row;
                
            }
        }];
    }];
    return path;
    
}

- (AdvancedLableNode *)spriteGridNodeAtPosition:(CGPoint)position
{
    NSArray *nodes = [self nodesAtPoint:position];
    __block AdvancedLableNode *result;
    
    for (int i = 0; i < 3; i ++) {
        NSArray *column = [self.spriteGrid objectAtIndex:i];
        [column enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([nodes containsObject:obj]) {
                AdvancedLableNode *node = obj;
                result = node;
            }
        }];
    }
    return result;
}

- (BOOL)isPositionBelongToListAkaSecondColumn:(CGPoint)position
{
    NSArray *nodes = [self nodesAtPoint:position];
    __block BOOL result = NO;
    NSArray *list = [self.spriteGrid objectAtIndex:1];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([nodes containsObject:obj]) {
            result = YES;
        }
    }];
    return result;
}

/**
 *If a point is belongs to a grid, returns a number between 0 and [self gridWidth]-1
 *If not, returns -1
*/
- (NSInteger)indexOfColumnInSpriteGridwithPosition:(CGPoint)position
{
    NSArray *nodes = [self nodesAtPoint:position];
    __block NSInteger result = -1;
    
    [self.spriteGrid enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *list = obj;
        NSUInteger index = idx;
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([nodes containsObject:obj]) {
                result = index;
            }
        }];
    }];
    return result;
}

- (NSInteger)indexOfArrayFormRelativeIndex:(NSInteger)relativeIndex withPageCount:(NSInteger)pageCount
{
    return pageCount * [self numberOfRowsPerPage] + relativeIndex;
}

#pragma mark - delegate

- (void)didAddProgram
{
    [self update];
}

- (void)didDeleteStatement:(Statement *)statement
{
    [self update];
}

- (void)didChangeCompilingStatementBlock:(NSMutableArray *)statementBlock
{
    [self update];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if ([button isEqualToString:OK]&&[alertView.title isEqualToString:FOR_QUERY_TITLE]) {
        [[Compiler sharedCompiler].statementBlock addObject:[[StatementWithConditionAndCommand alloc] initWithIdentifier:@"for"]];
        StatementWithConditionAndCommand *statement = [[Compiler sharedCompiler].statementBlock lastObject];
        statement.condition = [alertView textFieldAtIndex:0].text;
        [self update];
    }
}

@end
