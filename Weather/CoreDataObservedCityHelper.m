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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@", city.cityId];
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
    [newCity setValue:city.cityId forKey:@"cityId"];
    
    if (city.forecast != nil) {
        NSManagedObject *forecast = [[[CoreDataForecastHelper alloc] init] addForecast:city.forecast];
        [newCity setValue:forecast forKey:@"forecast"];
    }
    
    NSManagedObject *sunInfo = [[[CoreDataSunInfoHelper alloc] init] addSunfInfo:city.sunInfo];
    [newCity setValue:sunInfo forKey:@"sunInfo"];
    NSManagedObject *weatherConditions = [[[CoreDataWeatherConditions alloc] init] addWeatherConditions:city.weatherConditions];
    [newCity setValue:weatherConditions forKey:@"weatherConditions"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
}

- (void)updateObservedCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@", city.cityId];
    request.predicate = predicate;
    
    Forecast *forecast = nil;
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([result count] > 0) {
            ObservedCity *obsCity = [result firstObject];
            forecast = obsCity.forecast;
        }
    }
    
    city.forecast = forecast;
    [self removeObservedCity:city];
    [self addObservedCity:city];
}

- (void)updateObservedCity:(ObservedCity *)city withForecast:(Forecast *)forecast
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@", city.cityId];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error == nil) {
        if ([result count] > 0) {
            NSManagedObject *city = [result firstObject];
            [city setValue:[[[CoreDataForecastHelper alloc] init] addForecast:forecast] forKey:@"forecast"];
            [context save:&error];
        }
    }

}

- (BOOL)containsCity:(ObservedCity *)city
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"ObservedCity"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityId = %@", city.cityId];
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
