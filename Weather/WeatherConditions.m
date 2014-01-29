//
//  MainWeatherInfo.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherConditions.h"

@implementation WeatherConditions

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *main = [dictionary objectForKey:@"main"];
        self.humidity = [NSNumber numberWithInt:[[main objectForKey:@"humidity"] integerValue]];
        self.pressure = [NSNumber numberWithInt:[[main objectForKey:@"pressure"] integerValue]];
        self.temp = [NSNumber numberWithDouble:[[main objectForKey:@"temp"] doubleValue]];
        self.temp_max = [NSNumber  numberWithDouble:[[main objectForKey:@"temp_max"] doubleValue]];
        self.temp_min = [NSNumber numberWithDouble:[[main objectForKey:@"temp_min"] doubleValue]];
        
        NSDictionary *wind = [dictionary objectForKey:@"wind"];
        self.wind = [[Wind alloc] initWithNSJSONDictionary:wind];
        
        NSTimeInterval interval = [[dictionary objectForKey:@"dt"] integerValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSArray *weatherArray = [Weather weatherFromNSJSONArray:[dictionary objectForKey:@"weather"]];
        self.weather = [[NSSet alloc] initWithArray:weatherArray];
    }
    return self;
}

@end
