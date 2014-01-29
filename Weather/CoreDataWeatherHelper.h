//
//  CoreDataWeatherHelper.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"

@interface CoreDataWeatherHelper : NSObject

- (id)addWeather:(Weather *)weather;

@end
