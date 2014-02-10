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
@property (strong, nonatomic) UIViewController *viewController;

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

    self.viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loading_view_controller"];
    [self addChildViewController:self.viewController];
    [self.view addSubview:self.viewController.view];
    [self.viewController didMoveToParentViewController:self];
    
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
        CLLocation *location = [locations lastObject];
        
        [self.helper makeExplicitRequestWithLocations:location.coordinate.latitude lon:location.coordinate.longitude];
    }
    
    [self.manager stopUpdatingLocation];
}

#pragma mark - WeatherConnectionDelegate 

- (void)didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)explicitConnectionDidFinishedWithSucces:(ObservedCity *)city
{
    self.viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"weather_view_controller"];
    ((WeatherViewController *) self.viewController).city  = city;
    
    [self addChildViewController:self.viewController];
    [self.view addSubview:self.viewController.view];
    [self.viewController didMoveToParentViewController:self];
    
    self.addButton.enabled = YES;
}

#pragma mark - layout code

- (IBAction)addButtonDidClicked:(id)sender
{
    ObservedCity *city = ((WeatherViewController *) self.viewController).city;
    CoreDataObservedCityHelper *helper = [[CoreDataObservedCityHelper alloc] init];
    if ([helper containsCity:city]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"City already is observed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        [helper addObservedCity:city];
    }
}

@end
