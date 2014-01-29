//
//  CoreDataHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataObservedCityHelper.h"

@implementation CoreDataObservedCityHelper

- (void)removeObservedCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", city.cityName];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil && [result count] > 0) {
        [context deleteObject:[result objectAtIndex:0]];
        NSLog(@"Deleted: %@", city.cityName);
    }
}

- (void)clear
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    
    NSArray *result = [context executeFetchRequest:request error:nil];
    for (NSManagedObject *object in result) {
        [context deleteObject:object];
    }
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

- (void)addObservedCity:(ObservedCity *)city
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"ObservedCity" inManagedObjectContext:managedObjectContext];
    [newCity setValue:city.cityName forKey:@"cityName"];
    [newCity setValue:city.lat forKey:@"lat"];
    [newCity setValue:city.lon forKey:@"lon"];
    
    NSManagedObject *sunInfo = [[[CoreDataSunInfoHelper alloc] init] addSunfInfo:city.sunInfo];
    [newCity setValue:sunInfo forKey:@"sunInfo"];
    NSManagedObject *weatherConditions = [[[CoreDataWeatherConditions alloc] init] addWeatherConditions:city.weatherConditions];
    [newCity setValue:weatherConditions forKey:@"weatherConditions"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
    
    NSLog(@"Added city with name: %@", [newCity valueForKey:@"cityName"]);
}

- (void)updateObservedCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *cityObj = [self managedObjectForCity:city withContext:context];
    if (cityObj != nil) {
        [context deleteObject:cityObj];
        [self addObservedCity:city];
    }
}


- (void)updateObservedCity:(ObservedCity *)city withSunInfo:(SunInfo *)sunInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *cityObj = [self managedObjectForCity:city withContext:context];
    if (cityObj != nil) {
        if (cityObj != nil) {
            NSManagedObject *sunInfo = [[[CoreDataSunInfoHelper alloc] init] addSunfInfo:city.sunInfo];
            [cityObj setValue:sunInfo forKey:@"sunInfo"];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Error while saving: %@", error);
            } else {
                NSLog(@"Updated sun info in city: %@", city.cityName);
            }
        }
    }
}

- (BOOL)containsCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", city.cityName];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        for (ObservedCity *city in result) {
            if ([city.cityName isEqual:city.cityName]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSArray *)listOfCities
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];

    return [managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (ObservedCity *)cityWithName:(NSString *)cityName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([result count] > 0) {
            return [result objectAtIndex:0];
        }
    }
    
    return nil;
}

- (NSManagedObject *)managedObjectForCity:(ObservedCity *)city withContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", city.cityName];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([result count] > 0) {
            return [result objectAtIndex:0];
        }
    }
    
    return nil;
}

@end
