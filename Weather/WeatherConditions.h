//
//  MainWeatherInfo.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wind.h"
#import "Weather.h"

@interface WeatherConditions : NSObject

@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) NSNumber *temp;
@property (nonatomic, strong) NSNumber *temp_min;
@property (nonatomic, strong) NSNumber *temp_max;
@property (nonatomic, strong) Wind *wind;
@property (nonatomic, strong) NSSet *weather;
@property (nonatomic, strong) NSDate *date;

- (id) initWithNSJSONDictionary:(NSDictionary *)dictionary;

@end
