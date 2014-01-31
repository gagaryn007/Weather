//
//  YourLocalizationViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 28.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "YourLocalizationViewController.h"

@interface YourLocalizationViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) WeatherConnectionHelper *helper;
@property (strong, nonatomic) WeatherViewController *weatherViewController;

@end

@implementation YourLocalizationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.addButton.enabled = NO;
    
    self.helper = [[WeatherConnectionHelper alloc] init];
    self.helper.delegate = self;
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.manager startUpdatingLocation];
    
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"CLLocationManager error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0) {
        CLLocation *location = [locations objectAtIndex:0];
        
        [self.helper makeExplicitRequestWithLocations:location.coordinate.latitude lon:location.coordinate.longitude];
    }
    
    [self.manager stopUpdatingLocation];
}

#pragma mark - WeatherConnectionDelegate 

- (void)didFailWithError:(NSError *)error
{
    
}

- (void)explicitConnectionDidFinishedWithSucces:(ObservedCity *)city
{
    self.weatherViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"weather_view_controller"];
    self.weatherViewController.city  = city;
    
    [self addChildViewController:self.weatherViewController];
    [self.view addSubview:self.weatherViewController.view];
    [self.weatherViewController didMoveToParentViewController:self];
    
    self.addButton.enabled = YES;
}

- (void)likeConnectionDidFinishedWithSucces:(NSArray *)cityList
{
}

#pragma mark - layout code

- (IBAction)addButtonDidClicked:(id)sender
{
    CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
    if ([helper containsCity:self.weatherViewController.city]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"City already is observed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [helper addObservedCity:self.weatherViewController.city];
    }
}

@end
