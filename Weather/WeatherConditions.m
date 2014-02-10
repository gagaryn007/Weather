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
        
        Temperature *temperature = [[Temperature alloc] init];
        temperature.temp = [NSNumber numberWithDouble:[[main objectForKey:@"temp"] doubleValue]];
        temperature.temp_max = [NSNumber  numberWithDouble:[[main objectForKey:@"temp_max"] doubleValue]];
        temperature.temp_min = [NSNumber numberWithDouble:[[main objectForKey:@"temp_min"] doubleValue]];
        self.temperature = temperature;
        
        NSDictionary *wind = [dictionary objectForKey:@"wind"];
        self.wind = [[Wind alloc] initWithNSJSONDictionary:wind];
        
        NSTimeInterval interval = [[dictionary objectForKey:@"dt"] integerValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        NSArray *weatherArray = [Weather weatherFromNSJSONArray:[dictionary objectForKey:@"weather"]];
        self.weather = [[NSSet alloc] initWithArray:weatherArray];
        
        self.updateDate = [NSDate date];
    }
    return self;
}

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary andTemperatureNSJSONDictionary:(NSDictionary *)tempDictionary
{
    self = [super init];
    if (self) {
        self.humidity = [NSNumber numberWithInt:[[dictionary objectForKey:@"humidity"] integerValue]];
        self.pressure = [NSNumber numberWithInt:[[dictionary objectForKey:@"pressure"] integerValue]];
        
        Wind *wind = [[Wind alloc] init];
        wind.deg = [NSNumber numberWithInt:[[dictionary objectForKey:@"deg"] integerValue]];
        wind.speed = [NSNumber numberWithDouble:[[dictionary objectForKey:@"speed"] doubleValue]];
        self.wind = wind;
        
        NSArray *weatherArray = [Weather weatherFromNSJSONArray:[dictionary objectForKey:@"weather"]];
        self.weather = [[NSSet alloc] initWithArray:weatherArray];
        
        self.temperature = [[Temperature alloc] initWithNSJSONDictionary:tempDictionary];
        
        NSTimeInterval interval = [[dictionary objectForKey:@"dt"] integerValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:interval];
        
        self.updateDate = [NSDate date];
    }
    return self;
}

@end
