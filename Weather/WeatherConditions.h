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
#import "Temperature.h"

@interface WeatherConditions : NSObject

@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *pressure;
@property (nonatomic, strong) Wind *wind;
@property (nonatomic, strong) NSSet *weather;
@property (nonatomic, strong) NSDate *updateDate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Temperature *temperature;

- (id) initWithNSJSONDictionary:(NSDictionary *)dictionary;
- (id) initWithNSJSONDictionary:(NSDictionary *)dictionary andTemperatureNSJSONDictionary:(NSDictionary *)tempDictionary;

@end
