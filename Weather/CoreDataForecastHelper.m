//
//  CoreDataForecastHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataForecastHelper.h"
#import "CoreDataWeatherConditionsHelper.h"

@implementation CoreDataForecastHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addForecast:(Forecast *)forecast
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newForecast = [NSEntityDescription insertNewObjectForEntityForName:@"Forecast" inManagedObjectContext:context];
    
    CoreDataWeatherConditionsHelper *helper = [[CoreDataWeatherConditionsHelper alloc] init];
    NSMutableArray *weatherList = [[NSMutableArray alloc] init];
    for (WeatherConditions *weather in forecast.weatherConditions) {
        [weatherList addObject:[helper addWeatherConditions:weather]];
    }
    
    [newForecast setValue:[[NSSet alloc] initWithArray:weatherList] forKey:@"weatherConditions"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }

    return newForecast;
}

@end
