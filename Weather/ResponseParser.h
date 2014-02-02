//
//  ResponseParser.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 02.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherConnectionDelegate.h"

@protocol ResponseParser <NSObject>

- (void)parseNSJSONDictionary:(NSDictionary *)dictionary withDelegate:(id<WeatherConnectionDelegate>)delegate;

@end
