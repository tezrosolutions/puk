//
//  PukUser.m
//  Puk
//
//  Created by Muhammad Umair on 11/06/2014.
//  Copyright (c) 2014 Tezro Solutions. All rights reserved.
//

#import "PukUser.h"

@implementation PukUser



- (NSDictionary *) getDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:[NSNumber numberWithInt:_level] forKey:@"level"];
    [dict setValue:[NSNumber numberWithDouble:_score] forKey:@"score"];
    
    return dict;
}


- (void) setDictionary:(NSDictionary *)dict {
    _level = [[dict objectForKey:@"level"] intValue];
    _score = [[dict objectForKey:@"score"] doubleValue];
}


@end
