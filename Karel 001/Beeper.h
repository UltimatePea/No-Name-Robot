//
//  Beeper.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/31/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Position.h"
@interface Beeper : NSObject
- (instancetype)initWithPosition:(Position *)position;
@property (strong, nonatomic) Position *position;
@end
