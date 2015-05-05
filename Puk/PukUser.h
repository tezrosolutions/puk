//
//  PukUser.h
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PukUser : NSObject

@property int level;
@property double score;

- (void) setDictionary:(NSMutableDictionary *)dict;
- (NSMutableDictionary *) getDictionary;

@end
