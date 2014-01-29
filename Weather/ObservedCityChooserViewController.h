//
//  ObservedCityChooserViewController.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "ObservedCity.h"
#import "Weather.h"
#import "WeatherConnectionDelegate.h"
#import "WeatherConnectionHelper.h"
#import "CoreDataObservedCityHelper.h"
#import "ColorSelector.h"

@interface ObservedCityChooserViewController : UITableViewController <UISearchBarDelegate, WeatherConnectionDelegate>

@end
