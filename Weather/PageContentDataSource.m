//
//  PageContentDataSource.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 24.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//  1cf99c1a7c7356f6d6f0ef4d05260ddd

#import "PageContentDataSource.h"

@interface PageContentDataSource()

@property (strong, nonatomic) NSArray *cityList;

@end

@implementation PageContentDataSource

- (id)init
{
    self = [super init];
    if (self != nil) {
        CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
        self.cityList = [helper listOfCities];
    }
    
    return self;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WeatherViewController *) viewController).index;
    if (index == NSNotFound) {
        return nil;
    }
    
    [UIColor colorWithRed:255 green:255 blue:255 alpha:100];
    
    index++;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((WeatherViewController *) viewController).index;
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
