//
//  CoreDataWeatherConditions.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataWeatherConditionsHelper.h"
#import "CoreDataTemperatureHelper.h"

@implementation CoreDataWeatherConditionsHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addWeatherConditions:(WeatherConditions *)weatherConditions
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newWeatherConditions = [NSEntityDescription insertNewObjectForEntityForName:@"WeatherConditions" inManagedObjectContext:context];
    [newWeatherConditions setValue:weatherConditions.humidity forKey:@"humidity"];
    [newWeatherConditions setValue:weatherConditions.pressure forKey:@"pressure"];
    [newWeatherConditions setValue:[[[CoreDataWindHelper alloc] init] addWind:weatherConditions.wind] forKey:@"wind"];
    [newWeatherConditions setValue:weatherConditions.updateDate forKey:@"updateDate"];
    
    CoreDataWeatherHelper *weatherHelper = [[CoreDataWeatherHelper alloc] init];
    NSMutableArray *weatherArray = [NSMutableArray new];
    for (Weather *weather in weatherConditions.weather) {
        [weatherArray addObject:[weatherHelper addWeather:weather]];
    }
    
    [newWeatherConditions setValue:[[NSSet alloc] initWithArray:weatherArray] forKey:@"weather"];
    [newWeatherConditions setValue:weatherConditions.date forKey:@"date"];
    
    CoreDataTemperatureHelper *temperatureHelper = [[CoreDataTemperatureHelper alloc] init];
    [newWeatherConditions setValue:[temperatureHelper addTemperature:weatherConditions.temperature] forKey:@"temperature"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }

    return newWeatherConditions;
}

@end
