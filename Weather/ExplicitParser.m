//
//  ExplicitParser.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 02.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ExplicitParser.h"
#import "ObservedCity.h"

@implementation ExplicitParser

- (void)parseNSJSONDictionary:(NSDictionary *)dictionary withDelegate:(id<WeatherConnectionDelegate>)delegate
{
    ObservedCity *city = [[ObservedCity alloc] initWithNSJSONDictionary:dictionary];
    [delegate explicitConnectionDidFinishedWithSucces:city];
}

@end
