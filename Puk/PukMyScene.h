//
//  PukMyScene.h
//  Puk
//

//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PukMyScene : SKScene <SKPhysicsContactDelegate>

-(id)initWithSize:(CGSize)size AndLevel: (int) level;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (nonatomic) SKSpriteNode * player, *base;

@property (nonatomic) NSTimeInterval intervalSinceLevelStarted;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;



@property int level;



@end
