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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", city.identifier];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil && [result count] > 0) {
        [context deleteObject:[result objectAtIndex:0]];
        [context save:&error];
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
    
    [context save:nil];
}

- (void)addObservedCity:(ObservedCity *)city
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"ObservedCity" inManagedObjectContext:managedObjectContext];
    [newCity setValue:city.cityName forKey:@"cityName"];
    [newCity setValue:city.lat forKey:@"lat"];
    [newCity setValue:city.lon forKey:@"lon"];
    [newCity setValue:[self nextIdNumber] forKey:@"identifier"];
    
    NSManagedObject *sunInfo = [[[CoreDataSunInfoHelper alloc] init] addSunfInfo:city.sunInfo];
    [newCity setValue:sunInfo forKey:@"sunInfo"];
    NSManagedObject *weatherConditions = [[[CoreDataWeatherConditions alloc] init] addWeatherConditions:city.weatherConditions];
    [newCity setValue:weatherConditions forKey:@"weatherConditions"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
}

- (void)updateObservedCity:(ObservedCity *)city withIdentifier:(NSNumber *)identifier
{
    city.identifier = identifier;
    [self removeObservedCity:city];
    [self addObservedCity:city withIdentifier:identifier];
}

- (BOOL)containsCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@ AND lat = %@ AND lon = %@", city.cityName, city.lat, city.lon];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([result firstObject] != nil) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)allCities
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    
    return [managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - private

- (void)addObservedCity:(ObservedCity *)city withIdentifier:(NSNumber *)identifier
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newCity = [NSEntityDescription insertNewObjectForEntityForName:@"ObservedCity" inManagedObjectContext:managedObjectContext];
    [newCity setValue:city.cityName forKey:@"cityName"];
    [newCity setValue:city.lat forKey:@"lat"];
    [newCity setValue:city.lon forKey:@"lon"];
    [newCity setValue:identifier forKey:@"identifier"];
    
    NSManagedObject *sunInfo = [[[CoreDataSunInfoHelper alloc] init] addSunfInfo:city.sunInfo];
    [newCity setValue:sunInfo forKey:@"sunInfo"];
    NSManagedObject *weatherConditions = [[[CoreDataWeatherConditions alloc] init] addWeatherConditions:city.weatherConditions];
    [newCity setValue:weatherConditions forKey:@"weatherConditions"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
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


- (NSNumber *)nextIdNumber
{
    NSArray *cities = [self allCities];
    if ([cities count] > 0) {
        NSArray *sorted = [cities sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            ObservedCity *city1 = obj1;
            ObservedCity *city2 = obj2;
            
            return [city1.identifier compare:city2.identifier];
        }];
        
        return [NSNumber numberWithInt:([[[sorted lastObject] valueForKey:@"identifier"] integerValue] + 1)];
    } else {
        return [NSNumber numberWithInt:0];
    }
    
    return [NSNumber numberWithInt:0];
}



@end
