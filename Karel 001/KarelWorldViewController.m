//
//  KarelWorldViewController.m
//  Karel 001
//
//  Created by Chen Zhibo on 12/25/14.
//  Copyright (c) 2014 Chen Zhibo. All rights reserved.
//

#import "KarelWorldViewController.h"
#import "KarelWorldScene.h"

@interface KarelWorldViewController ()

@end

@implementation KarelWorldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
    SKView *skView = (SKView *)self.view;
    if (skView) {
        KarelWorldScene *worldNode = [[KarelWorldScene alloc] initWithSize:skView.bounds.size withKarelWorldMap:[[KarelWorldMap alloc] initWithMap:self.karelWorldMapSerial]];
        SKScene *scene = [SKScene sceneWithSize:skView.bounds.size];
        [scene addChild:worldNode];
        //scene.presentingVC = self;
        [skView presentScene:scene];
    }
    
}
/*
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
*/
@end
