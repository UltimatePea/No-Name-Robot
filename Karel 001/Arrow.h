//
//  Arrow.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/19/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Arrow : SKSpriteNode
//must call in sequence
- (void)didStartMoveAtPoint:(CGPoint)position;
- (void)didMoveToPosition:(CGPoint)position;
- (void)didEndMoveAtPoint:(CGPoint)position;

@end
