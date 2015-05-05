//
//  PukViewController.m
//  Puk
//
//  Created by Muhammad Umair on 10/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukViewController.h"
#import "PukMyScene.h"
#import "PukMain.h"

@implementation PukViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        //skView.showsFPS = YES;
        //skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        //SKScene * scene = [PukMyScene sceneWithSize:skView.bounds.size];
        SKScene * scene = [PukMain sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
