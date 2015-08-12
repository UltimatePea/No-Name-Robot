//
//  Position.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/31/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Position : NSObject

- (instancetype)initWithX:(NSUInteger)x withY:(NSUInteger)y;

@property (nonatomic) NSUInteger xCoordinate;
@property (nonatomic) NSUInteger yCoordinate;
- (BOOL)isEqualToPosition:(Position *)position;
@end
