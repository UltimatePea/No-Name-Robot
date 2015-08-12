//
//  CoordinateManager.h
//  No Name Robot
//
//  Created by Chen Zhibo on 1/24/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface CoordinateManager : NSObject

- (instancetype)initWithSize:(CGSize)size withGridWidth:(NSInteger)gridWidth withGridHeight:(NSInteger)gridHeight;

@property (nonatomic) NSInteger gridWidth, gridHeight;
@property (nonatomic) CGSize size;

- (CGFloat)horizontalSectionWidth;
- (CGFloat)verticalSectionHeight;
- (CGFloat)absoluteCenterPositionXWithRelativePosition:(CGFloat)xCoordinate withOffset:(CGFloat)offset;
- (CGFloat)absoluteCenterPositionYWithRelativePosition:(CGFloat)yCoordinate withOffset:(CGFloat)offset;
- (CGSize)standardNodeSize;
- (CGPoint)absoluteCenterPositionOfNodeOfRelativeCoordinate:(CGPoint)position;


@end
