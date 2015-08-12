//
//  AdvancedLableNode.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AdvancedLableNode : SKSpriteNode

@property (strong, nonatomic) NSString *label;
- (instancetype)initWithImageNamed:(NSString *)name withString:(NSString *)label;

@end
