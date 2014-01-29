//
//  CoreDataWeatherConditions.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataWeatherHelper.h"
#import "CoreDataWindHelper.h"
#import "WeatherConditions.h"
#import "Wind.h"

@interface CoreDataWeatherConditions : NSObject

- (id)addWeatherConditions:(WeatherConditions *)weatherConditions;

@end
