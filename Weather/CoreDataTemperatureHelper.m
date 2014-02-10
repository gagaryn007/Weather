//
//  CoreDataTemperatureHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 06.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataTemperatureHelper.h"

@implementation CoreDataTemperatureHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addTemperature:(Temperature *)temperature
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newTemperature = [NSEntityDescription insertNewObjectForEntityForName:@"Temperature" inManagedObjectContext:managedObjectContext];
    [newTemperature setValue:temperature.temp forKey:@"temp"];
    [newTemperature setValue:temperature.temp_max forKey:@"temp_max"];
    [newTemperature setValue:temperature.temp_min forKey:@"temp_min"];
    [newTemperature setValue:temperature.eve forKey:@"eve"];
    [newTemperature setValue:temperature.day forKey:@"day"];
    [newTemperature setValue:temperature.night forKey:@"night"];
    [newTemperature setValue:temperature.morn forKey:@"morn"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
    
    return newTemperature;
}

@end
