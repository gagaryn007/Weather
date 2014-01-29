//
//  CoreDataHelper.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObservedCity.h"
#import "CoreDataSunInfoHelper.h"
#import "CoreDataWeatherConditions.h"
#import "WeatherConditions.h"

@interface CoreDataObservedCityHelper : NSObject

- (void)addObservedCity:(ObservedCity *)city;
- (void)updateObservedCity:(ObservedCity *)city;
- (void)removeObservedCity:(ObservedCity *)city;
- (void)updateObservedCity:(ObservedCity *)city withSunInfo:(SunInfo *)sunInfo;
- (BOOL)containsCity:(ObservedCity *)city;
- (NSArray *)listOfCities;
- (void)clear;
- (ObservedCity *)cityWithName:(NSString *)cityName;

@end
