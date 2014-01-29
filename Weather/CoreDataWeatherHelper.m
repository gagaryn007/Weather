//
//  CoreDataWeatherHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataWeatherHelper.h"

@implementation CoreDataWeatherHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addWeather:(Weather *)weather
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newWeather = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
    [newWeather setValue:weather.identifier forKey:@"identifier"];
    [newWeather setValue:weather.main forKey:@"main"];
    [newWeather setValue:weather.icon forKey:@"icon"];
    [newWeather setValue:weather.desc forKey:@"desc"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
    
    return newWeather;
}

@end
