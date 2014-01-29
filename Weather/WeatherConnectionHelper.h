//
//  WeatherConnectionHelper.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherConnectionDelegate.h"
#import "ObservedCity.h"

@interface WeatherConnectionHelper : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) id <WeatherConnectionDelegate> delegate;

- (void)makeExplicitRequest:(NSString *)city;
- (void)makeLikeRequest:(NSString *)city;
- (void)makeExplicitRequestWithLocations:(double)lat lon:(double)lon;

@end
