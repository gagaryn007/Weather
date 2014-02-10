//
//  CoreDataTemperatureHelper.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 06.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Temperature.h"

@interface CoreDataTemperatureHelper : NSObject

- (id)addTemperature:(Temperature *)temperature;

@end
