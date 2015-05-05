//
//  GameOverScene.m
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukIntermediaryScene.h"
#import "PukMain.h"
#import "PukMyScene.h"
#import "PukPersistance.h"

static const int topOffSet = 100;
static const int bottomMargin = 80;
static const int gap = 70;
static const int leftRightMargin = 80;


static const int totalLevels = 4;

static const double firstLevelScore = 10.0;
static const double secondLevelScore = 20.0;
static const double thirdLevelScore = 30.0;
static const double fourthLevelScore = 40.0;





@implementation PukIntermediaryScene {
    PukPersistance *_instance;
    BOOL allLevelCleared;
    PukMyScene *gameScene;
}

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    _instance = [PukPersistance sharedInstance];
    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"puk_bg"];
        
        bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        bg.name = @"background";
        
        [self addChild:bg];
        
        
        allLevelCleared = NO;
        NSString * message;
        
        NSString *score;
        
        if (won) {//All Levels Cleared
            [self setScore];
            
            score = [NSString stringWithFormat:@"SCORE: %i", (int)_instance.user.score];

            _instance.user.level++;
            
            
            

            if(_instance.user.level >= (totalLevels + 1)) {//All Levels cleared
                allLevelCleared = YES;
                message = @"ALL LEVELS CLEARED!";
                [self allLevelCleared];
                
            } else {//Proceed to next level
                message = @"LEVEL CLEARED!";
               [self proceedToNextLevel];
            }
            
        } else {//Game over
            
            score = [NSString stringWithFormat:@"SCORE: %i", (int)_instance.user.score];

            message = @"GAME OVER";
            [self gameOver];
        }
        

        
        //Add labels which are supposed to be there in every case
        SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        
        scoreLabel.text = score;
        scoreLabel.fontSize = 20;
        scoreLabel.fontColor = [SKColor redColor];
        scoreLabel.position = CGPointMake(self.size.width/2, self.size.height/2 + topOffSet);
        [self addChild:scoreLabel];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label.text = message;
        label.fontSize = 28;
        label.fontColor = [SKColor redColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        
        
    }
    return self;
}


#pragma custom methods

- (void) setScore {
    
    switch(_instance.user.level) {
        case 1:
            _instance.user.score = _instance.user.score + firstLevelScore;
            break;
        case 2:
            _instance.user.score  = _instance.user.score + secondLevelScore;
            break;
        case 3:
            _instance.user.score = _instance.user.score + thirdLevelScore;
            break;
        case 4:
            _instance.user.score = _instance.user.score + fourthLevelScore;
            break;
            
    }
    
    
    
    
    [_instance saveDefaults];
}



- (void) allLevelCleared {
    _instance.user.level = 1;
    _instance.user.score = 0.0;
    
    [_instance saveDefaults];
    
    [self addFinalButtons];
}


-(void) proceedToNextLevel {
    [self runAction: [SKAction sequence:@[[SKAction waitForDuration:3.0],
                                          [SKAction runBlock:^{
        [self presentNextLevel];
    }
                                           
                                           ]]
                      ]
     ];
}

- (void) presentNextLevel {
    [_instance saveDefaults];
    
    
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    
    
    gameScene = [[PukMyScene alloc] initWithSize:self.size AndLevel: _instance.user.level];
    [self.view presentScene:gameScene transition: reveal];
}


- (void) gameOver {
    _instance.user.level = 0;
    _instance.user.score = 0.0;
    
    [_instance saveDefaults];
    
    [self addFinalButtons];
    
}



//All buttons that are supposed be on AllLevelCleared and GameOver Screen
- (void) addFinalButtons {
    SKSpriteNode *retryButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_retry"];
    
    retryButton.position = CGPointMake(self.frame.size.width/2, retryButton.size.height/2 + bottomMargin);
    retryButton.name = @"retry_button";
    [self addChild:retryButton];
    
    SKSpriteNode *mainButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_main"];
    
    mainButton.position = CGPointMake(leftRightMargin, retryButton.frame.origin.y + gap + mainButton.size.height/2);
    mainButton.name = @"main_button";
    
    [self addChild:mainButton];
    
    
    SKSpriteNode *shareButton = [SKSpriteNode spriteNodeWithImageNamed:@"button_share"];
    
    shareButton.position = CGPointMake(self.frame.size.width - leftRightMargin, retryButton.frame.origin.y + gap + mainButton.size.height/2);
    shareButton.name = @"share_button";
    
    [self addChild:shareButton];
    
    
}

#pragma delegate methods
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"retry_button"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        gameScene = [[PukMyScene alloc] initWithSize:self.size];
        
        
        [self.view presentScene:gameScene transition: reveal];
    }
    
    
    if ([node.name isEqualToString:@"main_button"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * mainScene = [[PukMain alloc] initWithSize:self.size];
        
        
        [self.view presentScene:mainScene transition: reveal];
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
