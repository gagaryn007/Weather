//
//  WeatherMapViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 03.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherMapViewController.h"

@interface WeatherMapViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation WeatherMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.manager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"weatherMap" ofType:@".html"];
    NSString *html = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    [self.webView loadHTMLString:[NSString stringWithFormat:html, @69, @69] baseURL:nil];
    
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([locations count] > 0) {
        CLLocation *location = [locations firstObject];
        NSNumber *lat = [NSNumber numberWithDouble:location.coordinate.latitude];
        NSNumber *lon = [NSNumber numberWithDouble:location.coordinate.longitude];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"weatherMap" ofType:@".html"];
        NSString *html = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
        [self.webView loadHTMLString:[NSString stringWithFormat:html, lat, lon] baseURL:nil];
    }
    
    [self.manager stopUpdatingLocation];
}

@end
