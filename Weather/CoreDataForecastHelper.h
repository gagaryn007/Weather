//
//  CoreDataForecastHelper.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecast.h"

@interface CoreDataForecastHelper : NSObject

- (id)addForecast:(Forecast *)forecast;

@end
