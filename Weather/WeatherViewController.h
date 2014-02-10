//
//  WeatherViewController.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservedCity.h"
#import "SWRevealViewController.h"
#import "ColorChooser.h"
#import "WeatherConnectionDelegate.h"
#import "WeatherConnectionHelper.h"
#import "CoreDataObservedCityHelper.h"

@interface WeatherViewController : UIViewController <WeatherConnectionDelegate>

@property (nonatomic, strong) ObservedCity *city;
@property (nonatomic) NSUInteger index;

@end
