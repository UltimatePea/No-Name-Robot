//
//  Arrow.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/19/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "Arrow.h"

@interface Arrow ()

@property (nonatomic) CGPoint initialPosition, currentPosition;
@property (nonatomic) BOOL didStartMove;

@end

@implementation Arrow

- (instancetype)init
{
    self = [super initWithImageNamed:@"arrow"];
    if (self) {
        self.hidden = YES;
        
    }
    return self;

}

- (void)didStartMoveAtPoint:(CGPoint)position
{
    self.initialPosition = position;
    self.didStartMove = YES;
}

- (void)didMoveToPosition:(CGPoint)position
{
    if (self.didStartMove) {
        self.currentPosition = position;
        self.hidden = NO;
        [self updatePosition];
    }
    
}

- (void)didEndMoveAtPoint:(CGPoint)position
{
    self.hidden = YES;
    
    
}

- (void)updatePosition
{
    CGFloat run = self.currentPosition.x - self.initialPosition.x;//dx
    CGFloat rise = self.currentPosition.y - self.initialPosition.y;//dy
    self.position = CGPointMake( self.initialPosition.x + run / 2, self.initialPosition.y +  rise / 2 );
    self.size = CGSizeMake(sqrt(run * run + rise * rise), sqrt(run * run + rise * rise) / 4);
    
    
    self.zRotation = atan(rise / run);
    if (run < 0) {
        self.zRotation += M_PI;
    }
    //NSLog(@"arrow z Rotation: %f", self.zRotation);
}


@end
