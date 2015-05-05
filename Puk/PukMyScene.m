//
//  PukMyScene.m
//  Puk
//
//  Created by Muhammad Umair on 10/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukMyScene.h"
#import "PukIntermediaryScene.h"
#import "PukPersistance.h"


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static const uint32_t mainDiscCategory     =  0x1 << 0;
static const uint32_t systemDiscCategory     =  0x1 << 1;
static const uint32_t baseCategory     =  0x1 << 2;
static const uint32_t edgeCategory     =  0x1 << 3;


static const int thurstFactor = 12;
static const int bottomMargin = 20;
static const int topMargin = 40;


//level constants
static const int firstLevelDiscMargin = 100;

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

static inline CGFloat dotProduct(CGPoint a, CGPoint b) {
    return (a.x * b.x) + (a.y * b.y);
}

@implementation PukMyScene {
    CGPoint touchLocation;
    Boolean mainDiscMoving;
    NSDate *touchBeganTime;
    
    PukPersistance *_instance;
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _instance = [PukPersistance sharedInstance];

        if(_instance.user.level == 0) {
            
            _instance.user.level = _level = 1;
            _instance.user.score = 0.0;

            
            [_instance saveDefaults];
        } else {
            _level = _instance.user.level;
        }
        
        
        [self configureSceneScreen];

        
        [self addPlayerDisc];
        
        
        [self addSystemDiscs];
        
        
        [self addBase];
        
        
        
        
    }
    return self;
}


-(id)initWithSize:(CGSize)size AndLevel: (int) level {
    if (self = [super initWithSize:size]) {
        _instance = [PukPersistance sharedInstance];
        
        _level = level;
                
        [self configureSceneScreen];
        
        [self addPlayerDisc];
        
        
        [self addSystemDiscs];
        
        
        [self addBase];
        
        
        
        
    }
    return self;
}






#pragma Custom methods

- (void) configureSceneScreen {
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    CGRect screenRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect];
    self.physicsBody.categoryBitMask = edgeCategory;
    self.physicsBody.collisionBitMask = mainDiscCategory | systemDiscCategory;
    self.physicsBody.friction = 0.0f;
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
}

- (void) addPlayerDisc {
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"main_disc"];
    self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.height/2 + bottomMargin);
    self.player.name = @"main_disc";
    self.player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.player.size.width * 0.5];
    self.player.physicsBody.dynamic = YES;
    self.player.physicsBody.categoryBitMask = mainDiscCategory;
    self.player.physicsBody.contactTestBitMask = systemDiscCategory | baseCategory;
    self.player.physicsBody.collisionBitMask = systemDiscCategory | edgeCategory | baseCategory;
    self.player.physicsBody.linearDamping = 1.0f;
    [self addChild:self.player];
    
}


- (void) addSystemDiscs {
    switch(_level) {
        case 1:
            [self setupFirstLevel];
            break;
        case 2:
            [self setupSecondLevel];
            break;
        case 3:
            [self setupThirdLevel];
            break;
        case 4:
            [self setupFourthLevel];
            break;
    }
}






- (void) addBase {
    self.base = [SKSpriteNode spriteNodeWithImageNamed:@"goal_post"];
    self.base.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - self.base.size.height/2 - topMargin );
    self.base.name = @"main_disc";
    self.base.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.base.size];
    self.base.physicsBody.dynamic = NO;
    self.base.physicsBody.categoryBitMask = baseCategory;
    self.base.physicsBody.contactTestBitMask = mainDiscCategory;
    self.base.physicsBody.collisionBitMask = systemDiscCategory | mainDiscCategory;
    self.base.physicsBody.linearDamping = 1.0f;
    [self addChild:self.base];
}


- (void)mainDisc:(SKSpriteNode *)mainDisc didCollideWithSystemDisc:(SKSpriteNode *)systemDisc {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * intermediaryScene = [[PukIntermediaryScene alloc] initWithSize:self.size won:NO];
    
    
    [self.view presentScene:intermediaryScene transition: reveal];
}


-(void) mainDisc:(SKSpriteNode *) mainDisc didCollideWithBase:(SKSpriteNode *) base {
    self.player.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    SKScene * intermediaryScene = [[PukIntermediaryScene alloc] initWithSize:self.size won:YES];
    
    
    [self.view presentScene:intermediaryScene transition: reveal];
}



//Setting up levels
-(void) setupFirstLevel {
    //Do nothing
}


-(void) setupSecondLevel {
    //First Disc
    SKSpriteNode *firstSystemDisc = [SKSpriteNode spriteNodeWithImageNamed:@"disc_orange"];
    
    firstSystemDisc.position = CGPointMake( self.frame.size.width - firstLevelDiscMargin, (firstSystemDisc.size.height + self.frame.size.height)/2);
    [self addChild:firstSystemDisc];
    
    firstSystemDisc.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: firstSystemDisc.size.width * 0.5];
    firstSystemDisc.physicsBody.dynamic = YES;
    firstSystemDisc.physicsBody.categoryBitMask = systemDiscCategory;
    firstSystemDisc.physicsBody.contactTestBitMask = mainDiscCategory;
    firstSystemDisc.physicsBody.collisionBitMask = mainDiscCategory | edgeCategory | baseCategory;
    
    
    
}




-(void) setupThirdLevel {
    //First Disc
    SKSpriteNode *firstSystemDisc = [SKSpriteNode spriteNodeWithImageNamed:@"disc_orange"];
    
    firstSystemDisc.position = CGPointMake( firstLevelDiscMargin, (firstSystemDisc.size.height + self.frame.size.height)/2);
    [self addChild:firstSystemDisc];
    
    firstSystemDisc.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: firstSystemDisc.size.width * 0.5];
    firstSystemDisc.physicsBody.dynamic = YES;
    firstSystemDisc.physicsBody.categoryBitMask = systemDiscCategory;
    firstSystemDisc.physicsBody.contactTestBitMask = mainDiscCategory;
    firstSystemDisc.physicsBody.collisionBitMask = mainDiscCategory | edgeCategory | baseCategory;
    
    
    //Second Disc
    SKSpriteNode *secondSystemDisc = [SKSpriteNode spriteNodeWithImageNamed:@"disc_grey"];
    
    secondSystemDisc.position = CGPointMake( self.frame.size.width - firstLevelDiscMargin, (secondSystemDisc.size.height + self.frame.size.height)/2);
    [self addChild:secondSystemDisc];
    
    secondSystemDisc.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: secondSystemDisc.size.width * 0.5];
    secondSystemDisc.physicsBody.dynamic = YES;
    secondSystemDisc.physicsBody.categoryBitMask = systemDiscCategory;
    secondSystemDisc.physicsBody.contactTestBitMask = mainDiscCategory;
    secondSystemDisc.physicsBody.collisionBitMask = mainDiscCategory | edgeCategory | baseCategory;
}


-(void) setupFourthLevel {
    //First Disc
    SKSpriteNode *firstSystemDisc = [SKSpriteNode spriteNodeWithImageNamed:@"disc_orange"];
    
    firstSystemDisc.position = CGPointMake( firstLevelDiscMargin, (firstSystemDisc.size.height + self.frame.size.height)/3);
    [self addChild:firstSystemDisc];
    
    firstSystemDisc.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: firstSystemDisc.size.width * 0.5];
    firstSystemDisc.physicsBody.dynamic = YES;
    firstSystemDisc.physicsBody.categoryBitMask = systemDiscCategory;
    firstSystemDisc.physicsBody.contactTestBitMask = mainDiscCategory;
    firstSystemDisc.physicsBody.collisionBitMask = mainDiscCategory | edgeCategory | baseCategory;
    
}


#pragma delegate and related methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    touchLocation = location;
    
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"main_disc"]) {
        mainDiscMoving = YES;
    } else {
        mainDiscMoving = NO;
    }
    
    touchBeganTime = [NSDate date];
    
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    NSTimeInterval timeBetween = [[NSDate date] timeIntervalSinceDate: touchBeganTime];
    
    if(mainDiscMoving) {
        CGPoint resVector = rwSub(location, touchLocation);
        float angle = atan2f (resVector.y, resVector.x) ;
        
        CGFloat thrust = thurstFactor/timeBetween;
        
        CGPoint thrustVector = CGPointMake(thrust*cosf(angle), thrust*sinf(angle));
        
        [self.player.physicsBody applyImpulse:CGVectorMake(thrustVector.x, thrustVector.y)];
    }
    
    
}



- (void)update:(NSTimeInterval)currentTime {
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.intervalSinceLevelStarted += timeSinceLast;
    if (self.intervalSinceLevelStarted > 10) {
        self.intervalSinceLevelStarted = 0;
        //[self presentGameOverFrame];
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    
    if (firstBody.categoryBitMask == mainDiscCategory && secondBody.categoryBitMask == systemDiscCategory) {
        [self mainDisc:(SKSpriteNode *) firstBody.node didCollideWithSystemDisc:(SKSpriteNode *) secondBody.node];
    }
    
    if (firstBody.categoryBitMask == mainDiscCategory && secondBody.categoryBitMask == baseCategory) {
        [self mainDisc:(SKSpriteNode *) firstBody.node didCollideWithBase:(SKSpriteNode *) secondBody.node];
    }
    
    
    
}



@end
