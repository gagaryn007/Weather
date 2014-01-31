//
//  WeatherForecast.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];

    if (self) {
        self.updateDate = [NSDate date];
    }
    
    return self;
}

@end
