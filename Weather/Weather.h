//
//  WeatherInfo.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherConditions.h"

@interface Weather : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *main;
@property (nonatomic, strong) NSString *desc;

+ (NSArray *) weatherFromNSJSONArray:(NSArray *)array;

@end
