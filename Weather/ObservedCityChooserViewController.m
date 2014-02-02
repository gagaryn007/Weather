//
//  ObservedCityChooserViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ObservedCityChooserViewController.h"

@interface ObservedCityChooserViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) WeatherConnectionHelper *weatherHelper;
@property (strong, nonatomic) NSArray *cityList;
@property (strong, nonatomic) NSMutableArray *selectionList;
@property (strong, nonatomic) CoreDataObservedCityHelper *helper;

@end

@implementation ObservedCityChooserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.helper = [[CoreDataObservedCityHelper alloc] init];
    
    self.weatherHelper = [[WeatherConnectionHelper alloc] init];
    self.weatherHelper.delegate = self;
    
    self.selectionList = [[NSMutableArray alloc] init];
    
    self.searchBar.delegate = self;
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
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
    return [self.cityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIFont *weatherFont = [UIFont fontWithName:@"Weather&Time" size:40];
    
    UILabel *cityLabel = (UILabel *) [cell viewWithTag:100];
    UILabel *tempLabel = (UILabel *) [cell viewWithTag:101];
    UILabel *weatherFirstLabel = (UILabel *) [cell viewWithTag:102];
    UILabel *weatherSecondLabel = (UILabel *) [cell viewWithTag:103];
    weatherFirstLabel.font = weatherFont;
    weatherSecondLabel.font = weatherFont;
    
    ObservedCity *city = [self.cityList objectAtIndex:indexPath.row];
    NSMutableString *cityNameAndCountry = [[NSMutableString alloc] init];
    [cityNameAndCountry appendString:city.cityName];

    if (city.country != nil) {
        [cityNameAndCountry appendString:@", "];
        [cityNameAndCountry appendString:city.country];
    }
    
    cityLabel.text = cityNameAndCountry;
    
    double celsiusTemp = [city.weatherConditions.temp doubleValue] - 273.15;
    NSString *celsiusTempStr = [NSString stringWithFormat:@"%.1lf°C", celsiusTemp];
    tempLabel.text = celsiusTempStr;
    
    weatherFirstLabel.text = @"";
    weatherSecondLabel.text = @"";
        
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *signsDictionary = nil;
    NSString *timeOfDay = nil;
    BOOL flag = YES;
    int index = 0;
    for (Weather *weather in city.weatherConditions.weather) {
        if (flag) {
            flag = NO;
            NSString *signsDictionaryPath = nil;
            timeOfDay = [weather.icon substringWithRange:NSMakeRange([weather.icon length] - 1, 1)];
            if ([timeOfDay isEqualToString:@"d"]) {
                signsDictionaryPath = [bundle pathForResource:@"Weather-day-images" ofType:@"plist"];
            } else {
                signsDictionaryPath = [bundle pathForResource:@"Weather-night-images" ofType:@"plist"];
            }
            
            signsDictionary = [[NSDictionary alloc] initWithContentsOfFile:signsDictionaryPath];
        }
        
        if (index == 0) {
            weatherFirstLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
        } else if (index == 1) {
            weatherSecondLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
        }
        
        index++;
    }
    
    cell.backgroundColor = [[[ColorSelector alloc] init] colorForTemperature:city.weatherConditions.temp andTimeOfDay:timeOfDay];
    
    if ([self.selectionList containsObject:city]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ObservedCity *selectedCity = [self.cityList objectAtIndex:indexPath.row];
    
    if ([self.selectionList containsObject:selectedCity]) {
        [self.selectionList removeObject:selectedCity];
        [self.helper removeObservedCity:selectedCity];
    } else {
        if (![self.helper containsCity:selectedCity]) {
            [self.weatherHelper makeExplicitRequest:selectedCity.cityId];
            [self.selectionList addObject:selectedCity];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"City already is observed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.weatherHelper makeLikeRequest:searchBar.text];
    [self.selectionList removeAllObjects];
    [searchBar resignFirstResponder];
}

#pragma mark - WeatherConnectionHelper delegate

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)likeConnectionDidFinishedWithSucces:(NSArray *)cityList
{
    self.cityList = cityList;
    [self.tableView reloadData];
}

- (void)explicitConnectionDidFinishedWithSucces:(ObservedCity *)city
{
    [self.helper addObservedCity:city];
}

@end
