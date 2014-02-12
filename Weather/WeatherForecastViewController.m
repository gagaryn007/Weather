//
//  WeatherForecastViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 31.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherForecastViewController.h"
#import "ColorChooser.h"
#import "CoreDataObservedCityHelper.h"

@interface WeatherForecastViewController ()

@property (strong, nonatomic) NSArray *weatherConditions;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayNightSegmentedControl;

@end

@implementation WeatherForecastViewController

#pragma mark - WeatherConnectionHelperDelegate

- (void)explicitConnectionDidFinishedWithSucces:(Forecast *)forecast
{
    NSArray *unsorted = [forecast.weatherConditions allObjects];
    self.weatherConditions = [unsorted sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        WeatherConditions *weather1 = obj1;
        WeatherConditions *weather2 = obj2;
        
        return [weather1.date compare:weather2.date];
    }];
    
    CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
    [helper updateObservedCity:self.city withForecast:forecast];
    
    [self.tableView reloadData];
}

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark - view methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.dayNightSegmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    
    if (self.city.forecast == nil) {
        WeatherConnectionHelper *helper = [[WeatherConnectionHelper alloc] init];
        helper.delegate = self;
        
        [helper makeForecastRequest:self.city.cityId];
    } else {
        NSArray *unsorted = [self.city.forecast.weatherConditions allObjects];
        self.weatherConditions = [unsorted sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            WeatherConditions *weather1 = obj1;
            WeatherConditions *weather2 = obj2;
        
            return [weather1.date compare:weather2.date];
        }];
        
        if ([self shouldUpdateForecast]) {
            WeatherConnectionHelper *helper = [[WeatherConnectionHelper alloc] init];
            helper.delegate = self;
            
            [helper makeForecastRequest:self.city.cityId];
        } else {
            [self.tableView reloadData];
        }
    }
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
    return [self.weatherConditions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherConditions *weatherConditions = [self.weatherConditions objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *temperatureLabel = (UILabel *) [cell viewWithTag:100];
    UILabel *descLabel = (UILabel *) [cell viewWithTag:101];
    UILabel *cityLabel = (UILabel *) [cell viewWithTag:102];
    UILabel *weatherUpperLabel = (UILabel *) [cell viewWithTag:103];
    UILabel *weatherLowerLabel = (UILabel *) [cell viewWithTag:104];
    UILabel *weatherMiddleLabel = (UILabel *) [cell viewWithTag:105];
    UILabel *dayOfMonthLabel = (UILabel *) [cell viewWithTag:106];
    UILabel *dayOfWeekLabel = (UILabel *) [cell viewWithTag:107];
    
    UIFont *font = [UIFont fontWithName:@"Weather&Time" size:40];
    weatherLowerLabel.text = @"";
    weatherMiddleLabel.text = @"";
    weatherUpperLabel.text = @"";
    weatherLowerLabel.font = font;
    weatherMiddleLabel.font = font;
    weatherUpperLabel.font = font;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd";
    NSString *dayOfMonth = [dateFormatter stringFromDate:weatherConditions.date];
    dateFormatter.dateFormat = @"EEEE";
    NSMutableString *dayOfWeek = [[[dateFormatter stringFromDate:weatherConditions.date] substringWithRange:NSMakeRange(0, 3)] mutableCopy];
    
    dayOfMonthLabel.text = dayOfMonth;
    dayOfWeekLabel.text = dayOfWeek;
    
    cityLabel.text = self.city.cityName;
    
    NSArray *weatherList = [weatherConditions.weather allObjects];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *timeOfDay = nil;
    NSString *signsDictionaryPath = nil;
    NSNumber *temp = nil;
    if (self.dayNightSegmentedControl.selectedSegmentIndex == 0) {
        signsDictionaryPath = [bundle pathForResource:@"Weather-day-images" ofType:@"plist"];
        timeOfDay = @"d";
        temp = weatherConditions.temperature.day;
    } else {
        signsDictionaryPath = [bundle pathForResource:@"Weather-night-images" ofType:@"plist"];
        timeOfDay = @"n";
        temp = weatherConditions.temperature.night;
    }
    
    NSString *temperatureStr = [NSString stringWithFormat:@"%.1lf", ([temp doubleValue] - 273.15)];
    temperatureLabel.text = temperatureStr;
    
    NSDictionary *signsDictionary = [[NSDictionary alloc] initWithContentsOfFile:signsDictionaryPath];
    if ([weatherList count] == 1) {
        Weather *weather = [weatherList firstObject];
        descLabel.text = weather.desc;
        weatherMiddleLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
    } else if ([weatherConditions.weather count] == 2) {
        Weather *weather1 = [weatherList firstObject];
        Weather *weather2 = [weatherList objectAtIndex:1];
        
        descLabel.text = [NSString stringWithFormat:@"%@, %@", weather1.desc, weather2.desc];
        weatherUpperLabel.text = [signsDictionary objectForKey:[weather1.identifier stringValue]];
        weatherLowerLabel.text = [signsDictionary objectForKey:[weather2.identifier stringValue]];
    }
    
    ColorChooser *chooser = [[ColorChooser alloc] init];
    UIColor *color = [chooser colorForTemperature:temp andTimeOfDay:timeOfDay];
    cell.backgroundColor = color;
    
    return cell;
}

#pragma mark - UISegmentedControl change event

- (void)segmentedControlDidChange:(id)sender
{
    [self.tableView reloadData];
}

#pragma mark - private

- (BOOL)shouldUpdateForecast
{
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = -2;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *forecastDate = [[self.weatherConditions firstObject] valueForKey:@"date"];
    NSDate *dateNow = [NSDate date];
    
    NSDate *date = [calendar dateByAddingComponents:offset toDate:dateNow options:0];
    NSComparisonResult result = [date compare:forecastDate];
    
    if (result == NSOrderedDescending) {
        return YES;
    }
    
    return NO;
}

@end
