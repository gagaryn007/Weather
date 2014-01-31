//
//  WeatherForecastViewController.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservedCity.h"
#import "WeatherConnectionHelper.h"
#import "WeatherConnectionDelegate.h"

@interface WeatherForecastViewController : UITableViewController <WeatherConnectionDelegate>

@property (strong, nonatomic) ObservedCity *city;

@end
