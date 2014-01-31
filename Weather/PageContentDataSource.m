//
//  PageContentDataSource.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 24.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//  1cf99c1a7c7356f6d6f0ef4d05260ddd

#import "PageContentDataSource.h"

@interface PageContentDataSource()

@property (strong, nonatomic) NSMutableArray *cityList;

@end

@implementation PageContentDataSource

- (id)init
{
    self = [super init];
    if (self != nil) {
        CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
        self.cityList = [[helper allCities] mutableCopy];
    }
    
    return self;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if ([viewController isKindOfClass:[WeatherViewController class]]) {
        index = ((WeatherViewController *) viewController).index;
    } else {
        return nil;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index;
    if ([viewController isKindOfClass:[WeatherViewController class]]) {
        index = ((WeatherViewController *) viewController).index;
    } else {
        return nil;
    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (WeatherViewController *)viewControllerAtIndex:(NSUInteger) index
{
    if (index >= [self.cityList count]) {
        return nil;
    }
    
    WeatherViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"weather_view_controller"];

    contentViewController.city = [self.cityList objectAtIndex:index];
    contentViewController.index = index;
    
    return contentViewController;
}

- (void)removeCity:(ObservedCity *)city
{
    CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
    [helper removeObservedCity:city];
    [self.cityList removeObject:city];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.cityList count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSUInteger)count
{
    return [self.cityList count];
}

@end
