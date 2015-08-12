//
//  DetailNodeScene.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/24/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Statement.h"

@protocol DetailedNodeSceneDelegate <NSObject>

@required

/**
 This method get called when user wants to delete a statement
 @param statement: the statement that has already been removed from the program
 */
- (void)didDeleteStatement:(Statement *)statement;

/**
 This method get called when user wants to edit a specific program
 @param statementBlock: The user desired statementBlock
 */
- (void)didChangeCompilingStatementBlock:(NSMutableArray *)statementBlock;


@end

@interface DetailNodeScene : SKSpriteNode

@property (weak, nonatomic) id<DetailedNodeSceneDelegate> delegate;

- (instancetype)initWithStatement:(Statement *)statement  withSize:(CGSize)size withDelegate:(id<DetailedNodeSceneDelegate>)delegate;

@end
