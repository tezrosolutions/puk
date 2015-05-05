//
//  PukPersistance.h
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PukUser.h"

@interface PukPersistance : NSObject

@property (nonatomic) PukUser *user;

+ (PukPersistance *)sharedInstance;
- (void)saveDefaults;

@end
