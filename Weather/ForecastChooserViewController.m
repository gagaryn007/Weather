//
//  ForecastChooserViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 30.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ForecastChooserViewController.h"

@interface ForecastChooserViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) CoreDataObservedCityHelper *helper;

@end

@implementation ForecastChooserViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    self.helper = [[CoreDataObservedCityHelper alloc] init];
    self.cities = [[self.helper allCities] mutableCopy];
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
    return [self.cities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"forecast_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ObservedCity *city = [self.cities objectAtIndex:indexPath.row];
    NSString *icon = [[[city.weatherConditions.weather allObjects] objectAtIndex:0] valueForKey:@"icon"];
    NSString *timeOfDay = [icon substringWithRange:NSMakeRange([icon length] - 1, 1)];
    UIColor *color = [[[ColorSelector alloc] init] colorForTemperature:city.weatherConditions.temp andTimeOfDay:timeOfDay];
    
    cell.backgroundColor = color;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [[self.cities objectAtIndex:indexPath.row] valueForKey:@"cityName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    WeatherForecastViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"weather_forecast_view_controller"];
    viewController.city = [self.cities objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ObservedCity *city = [self.cities objectAtIndex:indexPath.row];
        [self.helper removeObservedCity:city];
        [self.cities removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (IBAction)didClickEditButton:(id)sender {
    if (self.tableView.editing) {
        self.editButton.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    } else {
        self.editButton.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
    }
}

@end
