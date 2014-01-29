//
//  WeatherInfo.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (NSArray *)weatherFromNSJSONArray:(NSArray *)array
{
    NSMutableArray *resultArray = [NSMutableArray new];
    for (id obj in array) {
        Weather *weather = [[Weather alloc] init];
        weather.desc = [obj objectForKey:@"description"];
        weather.icon = [obj objectForKey:@"icon"];
        weather.identifier = [NSNumber numberWithInt:[[obj objectForKey:@"id"] integerValue]];
        weather.main = [obj objectForKey:@"main"];
        
        [resultArray addObject:weather];
    }
    return resultArray;
}

@end
