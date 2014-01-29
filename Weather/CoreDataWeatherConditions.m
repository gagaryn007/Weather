//
//  CoreDataWeatherConditions.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataWeatherConditions.h"

@implementation CoreDataWeatherConditions

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
    [newWeatherConditions setValue:weatherConditions.temp forKey:@"temp"];
    [newWeatherConditions setValue:weatherConditions.temp_max forKey:@"temp_max"];
    [newWeatherConditions setValue:weatherConditions.temp_min forKey:@"temp_min"];
    [newWeatherConditions setValue:[[[CoreDataWindHelper alloc] init] addWind:weatherConditions.wind] forKey:@"wind"];
    
    CoreDataWeatherHelper *weatherHelper = [[CoreDataWeatherHelper alloc] init];
    NSMutableArray *weatherArray = [NSMutableArray new];
    for (Weather *weather in weatherConditions.weather) {
        [weatherArray addObject:[weatherHelper addWeather:weather]];
    }
    
    [newWeatherConditions setValue:[[NSSet alloc] initWithArray:weatherArray] forKey:@"weather"];
    [newWeatherConditions setValue:weatherConditions.date forKey:@"date"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }

    return newWeatherConditions;
}

@end
