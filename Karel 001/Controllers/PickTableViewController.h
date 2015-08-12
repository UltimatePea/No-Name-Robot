//
//  PickTableViewController.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/28/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewCammandTableViewController.h"

typedef enum : NSUInteger {
    PickResultTypeCommand,
    PickResultTypeCondition,
    PickResultTypeProgram,
    PickResultTypeMap
} PickResultType;

@protocol PickResult <NSObject>

@required
@property (strong, nonatomic) NSString *condition;

@property (strong, nonatomic) NSString *command;

@end


@interface PickTableViewController : UITableViewController

@property (nonatomic) PickResultType pickResultType;
@property (weak, nonatomic) id<PickResult> resultViewController;

@end
