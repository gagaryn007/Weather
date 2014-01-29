//
//  YourLocalizationViewController.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 28.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"
#import "WeatherViewController.h"
#import "WeatherConnectionHelper.h"
#import "WeatherConnectionDelegate.h"
#import "CoreDataObservedCityHelper.h"

@interface YourLocalizationViewController : UIViewController <CLLocationManagerDelegate, WeatherConnectionDelegate>

@end
