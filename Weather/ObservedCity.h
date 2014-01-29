//
//  ObservedCity.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherConditions.h"
#import "SunInfo.h"

@interface ObservedCity : NSObject

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) WeatherConditions *weatherConditions;
@property (strong, nonatomic) SunInfo *sunInfo;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;

- (id) initWithNSJSONDictionary:(NSDictionary *) dictionary;

@end
