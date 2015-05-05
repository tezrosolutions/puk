//
//  PukPersistance.m
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukPersistance.h"
static PukPersistance  *_instance = nil;

@implementation PukPersistance

+ (PukPersistance *)sharedInstance {
    @synchronized ([PukPersistance class]) {
        if (!_instance) {
            _instance = [[PukPersistance alloc] init];
        }
    }
    return _instance;
}


- (id)init {
    self = [super init];
    if (self) {
        self.user = [[PukUser alloc] init];
        
        [self loadDefaults];
    }
    
    return self;
}


- (void)loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *userDict = [defaults objectForKey:@"User"];
    
    self.user = [[PukUser alloc] init];
    [self.user setDictionary: userDict];
}

- (void)saveDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[self.user getDictionary]  forKey:@"User"];
    [defaults synchronize];
}


@end
