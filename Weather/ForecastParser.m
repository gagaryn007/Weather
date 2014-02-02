//
//  ForecastParser.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 02.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ForecastParser.h"

@implementation ForecastParser

- (void)parseNSJSONDictionary:(NSDictionary *)dictionary withDelegate:(id<WeatherConnectionDelegate>)delegate
{
    [delegate explicitConnectionDidFinishedWithSucces:dictionary];
}

@end
