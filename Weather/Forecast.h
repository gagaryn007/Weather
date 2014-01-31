//
//  WeatherForecast.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property (strong, nonatomic) NSDate *updateDate;
@property (strong, nonatomic) NSSet *weatherConditions;

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary;

@end
