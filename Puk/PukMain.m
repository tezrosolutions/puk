//
//  PukMain.m
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukMain.h"
#import "PukMyScene.h"

static const int topOffSet = 100;
static const int bottomMargin = 80;
static const int gap = 70;
static const int leftRightMargin = 80;

@implementation PukMain
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.physicsWorld.contactDelegate = self;

        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"puk_bg"];
        
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg.name = @"background";
        
        [self addChild:bg];
        
        
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
        logo.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2  + logo.size.height/2);
        logo.name = @"logo";
       
        [self addChild:logo];

        
        SKSpriteNode *playButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_play"];
        
        playButton.position = CGPointMake(self.frame.size.width/2, playButton.size.height/2 + bottomMargin);
        playButton.name = @"play_button";
        [self addChild:playButton];
        
        SKSpriteNode *boardButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_board"];
        
        boardButton.position = CGPointMake(leftRightMargin, playButton.frame.origin.y + gap + boardButton.size.height/2);
        boardButton.name = @"board_button";
        
        [self addChild:boardButton];
        
        
        SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_share"];
        
        shareButton.position = CGPointMake(self.frame.size.width - leftRightMargin, playButton.frame.origin.y + gap + boardButton.size.height/2);
        shareButton.name = @"share_button";
        
        [self addChild:shareButton];
        
    }
    return self;
}

/*
 -(id)initWithSize:(CGSize)size {
 if (self = [super initWithSize:size]) {
 // Replace @"Spaceship" with your background image:
 SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
 
 sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
 sn.name = @"BACKGROUND";
 
 [self addChild:sn];
 }
 return self;
 }
*/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"play_button"] || [node.name isEqualToString:@"board_button"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameScene = [[PukMyScene alloc] initWithSize:self.size];
        
        
        [self.view presentScene:gameScene transition: reveal];
    }
    
    
    if ([node.name isEqualToString:@"share_button"] ) {
        NSString *textToShare = @"Checkout this new game PUK!";
        UIImage *imageToShare = [UIImage imageNamed:@"logo.png"];
        NSArray *itemsToShare = @[textToShare, imageToShare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't
        
         UIViewController *vc = self.view.window.rootViewController;
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
    
    
    
}
@end
