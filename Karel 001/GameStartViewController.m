//
//  GameStartViewController.m
//  No Name Robot
//
//  Created by Chen Zhibo on 1/8/15.
//  Copyright (c) 2015 Chen Zhibo. All rights reserved.
//

#import "GameStartViewController.h"
#import "InitialScene.h"

@interface GameStartViewController ()

@end

@implementation GameStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    InitialScene *scene = [[InitialScene alloc] initWithSize:self.view.frame.size];
    //
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
    SKView *skView = (SKView *)self.view;
    [skView presentScene:scene];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
