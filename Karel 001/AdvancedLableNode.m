//
//  AdvancedLableNode.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/17/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "AdvancedLableNode.h"

@interface AdvancedLableNode ()

@property (strong,nonatomic) SKLabelNode *labelNode;

@end

@implementation AdvancedLableNode

- (SKLabelNode *)labelNode
{
    if (!_labelNode) {
        _labelNode = [[SKLabelNode alloc] init];
        _labelNode.fontSize = 16;
        _labelNode.fontColor = [UIColor blackColor];
        _labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    }
    return _labelNode;
}

- (instancetype)initWithImageNamed:(NSString *)name withString:(NSString *)label
{
    self = [super initWithImageNamed:name];
    if (self) {
        self.label = label;
        
        
        [self addChild:self.labelNode];
        
    }
    return self;
}

- (void)setLabel:(NSString *)label
{
    _label = label;
    if (label) {
        self.labelNode.text = label;
        [self updateLabelFont];
    } else {
        self.labelNode.text = @"[OMIT]";
    }
    
    
}

- (void)setSize:(CGSize)size
{
    [super setSize:size];
    
    [self updateLabelFont];
}


- (void)updateLabelFont
{
    while (self.labelNode.frame.size.width > self.size.width *(12 / 10)) {
        if (self.labelNode.fontSize > 1) {
             self.labelNode.fontSize --;
        } else {
            self.labelNode.fontSize = self.labelNode.fontSize / 2;
        }
       
    }
}




@end
