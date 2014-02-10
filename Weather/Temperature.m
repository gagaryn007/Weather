//
//  Temperature.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 06.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "Temperature.h"

@implementation Temperature

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.day = [NSNumber numberWithDouble:[[dictionary objectForKey:@"day"] doubleValue]];
        self.eve = [NSNumber numberWithDouble:[[dictionary objectForKey:@"eve"] doubleValue]];
        self.temp_max = [NSNumber numberWithDouble:[[dictionary objectForKey:@"max"] doubleValue]];
        self.temp_min = [NSNumber numberWithDouble:[[dictionary objectForKey:@"min"] doubleValue]];
        self.morn = [NSNumber numberWithDouble:[[dictionary objectForKey:@"morn"] doubleValue]];
        self.night = [NSNumber numberWithDouble:[[dictionary objectForKey:@"night"] doubleValue]];
    }

    return self;
}

@end
