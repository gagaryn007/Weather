//
//  PageContentDataSource.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 24.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataObservedCityHelper.h"
#import "WeatherViewController.h"

@interface PageContentDataSource : NSObject <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIStoryboard *storyboard;

- (WeatherViewController *)viewControllerAtIndex:(NSUInteger) index;
- (NSUInteger)count;

@end
