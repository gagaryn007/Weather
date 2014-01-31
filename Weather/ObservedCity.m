//
//  ObservedCity.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ObservedCity.h"

@implementation ObservedCity

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.cityId = [NSNumber numberWithInt:[[dictionary objectForKey:@"id"] integerValue]];
        
        NSDictionary *sys = [dictionary objectForKey:@"sys"];
        self.country = [sys objectForKey:@"country"];
        self.sunInfo = [[SunInfo alloc] initWithNSJSONDictionary:sys];
        self.cityName = [dictionary objectForKey:@"name"];
        self.weatherConditions = [[WeatherConditions alloc] initWithNSJSONDictionary:dictionary];
        
        NSDictionary *coord = [dictionary objectForKey:@"coord"];
        self.lat = [NSNumber numberWithDouble:[[coord objectForKey:@"lat"] doubleValue]];
        self.lon = [NSNumber numberWithDouble:[[coord objectForKey:@"lon"] doubleValue]];
    }
    return self;
}

@end
