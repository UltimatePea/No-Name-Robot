//
//  NewCammandTableViewController.h
//  Karel 001
//
//  Created by Chen Zhibo on 12/26/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UserDesiredCommandIf,
    UserDesiredCommandFor,
    UserDesiredCommandWhile,
} UserDesiredCommand;

@interface NewCammandTableViewController : UITableViewController

@property (nonatomic) UserDesiredCommand userDesiredCommand;


@property (strong, nonatomic) NSString *condition;

@property (strong, nonatomic) NSString *command;

@end
