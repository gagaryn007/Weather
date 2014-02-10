//
//  WeatherForecast.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "Forecast.h"
#import "WeatherConditions.h"

@implementation Forecast

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    NSMutableArray *weatherConditionsList = [NSMutableArray new];
    NSArray *array = [dictionary objectForKey:@"list"];
    for (NSDictionary *dictionary in array) {
        WeatherConditions *weatherConditions = [[WeatherConditions alloc] initWithNSJSONDictionary:dictionary andTemperatureNSJSONDictionary:[dictionary objectForKey:@"temp"]];
        [weatherConditionsList addObject:weatherConditions];
    }
    
    self.weatherConditions = [[NSSet alloc] initWithArray:weatherConditionsList];
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
