//
//  WeatherConnectionDelagate.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObservedCity.h"

@protocol WeatherConnectionDelegate <NSObject>

@required
- (void)didFailWithError:(NSError *)error;

@optional
- (void)explicitConnectionDidFinishedWithSucces:(id)obj;
- (void)likeConnectionDidFinishedWithSucces:(NSArray *)list;

@end
