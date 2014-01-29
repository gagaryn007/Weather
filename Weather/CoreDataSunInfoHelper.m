//
//  CoreDataSunInfoHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "CoreDataSunInfoHelper.h"

@implementation CoreDataSunInfoHelper

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (id)addSunfInfo:(SunInfo *)sunInfo
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSManagedObject *newSunInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SunInfo" inManagedObjectContext:managedObjectContext];
    [newSunInfo setValue:sunInfo.sunrise forKey:@"sunrise"];
    [newSunInfo setValue:sunInfo.sunset forKey:@"sunset"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving: %@", error);
    }
    
    NSLog(@"sunrise -> %@", [newSunInfo valueForKey:@"sunrise"]);
    
    return newSunInfo;
}



@end
