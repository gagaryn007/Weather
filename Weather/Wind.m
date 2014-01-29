//
//  WindInfo.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "Wind.h"

@implementation Wind

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.deg = [NSNumber numberWithInt:[[dictionary objectForKey:@"deg"] integerValue]];
        self.speed = [NSNumber numberWithDouble:[[dictionary objectForKey:@"speed"] doubleValue]];
    }
    
    return self;
}

@end
