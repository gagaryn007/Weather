//
//  WeatherForecastViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherForecastViewController.h"

@interface WeatherForecastViewController ()

@end

@implementation WeatherForecastViewController

- (void)explicitConnectionDidFinishedWithSucces:(NSDictionary *)obj
{
    NSLog(@"%@", obj);
}

- (void)likeConnectionDidFinishedWithSucces:(NSArray *)cityList
{
}

- (void)didFailWithError:(NSError *)error
{
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WeatherConnectionHelper *helper = [[WeatherConnectionHelper alloc] init];
    helper.delegate = self;
    
    [helper makeForecastRequest:self.city.cityId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.city.cityName;
    
    return cell;
}

@end
