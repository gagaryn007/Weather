//
//  CoreDataWindHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataWindHelper.h"

@implementation CoreDataWindHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addWind:(Wind *)wind
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newWind = [NSEntityDescription insertNewObjectForEntityForName:@"Wind" inManagedObjectContext:managedObjectContext];
    [newWind setValue:wind.deg forKey:@"deg"];
    [newWind setValue:wind.speed forKey:@"speed"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
    
    return newWind;
}

@end
