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
#import "CoreDataForecastHelper.h"
#import "WeatherConditions.h"

@interface CoreDataObservedCityHelper : NSObject

- (void)addObservedCity:(ObservedCity *)city;
- (void)updateObservedCity:(ObservedCity *)city;
- (void)updateObservedCity:(ObservedCity *)city withForecast:(Forecast *)forecast;
- (void)removeObservedCity:(ObservedCity *)city;
- (BOOL)containsCity:(ObservedCity *)city;
- (NSArray *)allCities;
- (void)clear;

@end
