//
//  WeatherViewController.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherViewController.h"
#import "AppDelegate.h"

@interface WeatherViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UITextView *fullInfoTextView;
@property (weak, nonatomic) IBOutlet UITextView *fullInfoLegendTextView;
@property (weak, nonatomic) IBOutlet UILabel *leftWeatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerWeatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightWeatherDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightWeatherLabel;

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods

- (void)updateLayout
{
    self.cityNameLabel.text = self.city.cityName;
    self.dateLabel.text = [self stringFromDate:self.city.weatherConditions.date];
    self.fullInfoTextView.attributedText = [self stringFromFullInfo];
    self.tempLabel.text = [NSString stringWithFormat:@"%.1lf°C", ([self.city.weatherConditions.temp doubleValue] - 273.15)];
    
    BOOL flag = YES;
    NSString *timeOfDay = nil;
    NSDictionary *signsDictionary = nil;
    UIFont *font = [UIFont fontWithName:@"Weather&Time" size:144];
    if ([self.city.weatherConditions.weather count] == 1) {
        self.leftWeatherDescriptionLabel.text = @"";
        self.rightWeatherDescriptionLabel.text = @"";
        self.leftWeatherLabel.text = @"";
        self.rightWeatherLabel.text = @"";
        
        for (Weather *weather in self.city.weatherConditions.weather) {
            self.centerWeatherDescriptionLabel.text = [weather.desc capitalizedString];
            self.centerWeatherLabel.font = font;
        
            if (flag) {
                flag = NO;
                timeOfDay = [self timeOfDayForIcon:weather.icon];
                signsDictionary = [self signsDictionaryForTimeOfDay:timeOfDay];
            }
            
            self.centerWeatherLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
        }
    } else {
        self.centerWeatherDescriptionLabel.text = @"";
        self.centerWeatherLabel.text = @"";
        
        int index = 0;
        for (Weather *weather in self.city.weatherConditions.weather) {
            if (flag) {
                flag = NO;
                timeOfDay = [self timeOfDayForIcon:weather.icon];
                signsDictionary = [self signsDictionaryForTimeOfDay:timeOfDay];
            }
            
            if (index == 0) {
                self.leftWeatherDescriptionLabel.text = [weather.desc capitalizedString];
                self.leftWeatherLabel.font = font;
                self.leftWeatherLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
            } else {
                self.rightWeatherDescriptionLabel.text = [weather.desc capitalizedString];
                self.rightWeatherLabel.font = font;
                self.rightWeatherLabel.text = [signsDictionary objectForKey:[weather.identifier stringValue]];
            }
            
            index++;
        }
    }
    
    ColorSelector *colorSelector = [[ColorSelector alloc] init];
    
    NSNumber *temp = self.city.weatherConditions.temp;
    UIColor *color = [colorSelector colorForTemperature:temp andTimeOfDay:timeOfDay];
    self.fullInfoTextView.backgroundColor = color;
    self.fullInfoLegendTextView.backgroundColor = color;
    self.view.backgroundColor = color;
}

- (NSAttributedString *)stringFromFullInfo
{
    NSString *humidity = [NSString stringWithFormat:@"%@ %%", self.city.weatherConditions.humidity];
    NSString *pressure = [NSString stringWithFormat:@"%@ hPa", self.city.weatherConditions.pressure];
    NSString *maxTemp = [NSString stringWithFormat:@"%.1lf°C", ([self.city.weatherConditions.temp_max doubleValue] - 273.15)];
    NSString *minTemp = [NSString stringWithFormat:@"%.1lf°C", ([self.city.weatherConditions.temp_min doubleValue] - 273.15)];

    NSString *windSpeed = [NSString stringWithFormat:@"%.2lf mps", [self.city.weatherConditions.wind.speed doubleValue]];
    NSString *windDirection = [NSString stringWithFormat:@"%@", [self stringForWindDirection:self.city.weatherConditions.wind.deg]];
    
    NSString *sunrise = [NSString stringWithFormat:@"%@", [self hourFromDate:self.city.sunInfo.sunrise]];
    NSString *sunset = [NSString stringWithFormat:@"%@", [self hourFromDate:self.city.sunInfo.sunset]];
    
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendString:humidity];
    [result appendString:@"\n"];
    [result appendString:pressure];
    [result appendString:@"\n"];
    [result appendString:maxTemp];
    [result appendString:@"\n"];
    [result appendString:minTemp];
    [result appendString:@"\n\n"];
    [result appendString:windSpeed];
    [result appendString:@"\n"];
    [result appendString:windDirection];
    [result appendString:@"\n\n"];
    [result appendString:sunrise];
    [result appendString:@"\n"];
    [result appendString:sunset];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentRight;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragrapStyle, NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:result attributes:attributes];
    
    return attributedString;
}

- (NSString *)stringForWindDirection:(NSNumber *)degNumber
{
    double deg = [degNumber doubleValue];
    
    if (deg >= 0 && deg <= 11.25) {
        return @"N";
    } else if (deg > 11.25 && deg <= 33.75) {
        return @"NNE";
    } else if (deg > 33.75 && deg <= 56.25) {
        return @"ENE";
    } else if (deg > 78.75 && deg <= 101.25) {
        return @"E";
    } else if (deg > 101.25 && deg <= 123.75) {
        return @"ESE";
    } else if (deg > 123.75 && deg <= 146.25) {
        return @"SE";
    } else if (deg > 146.25 && deg <= 168.75) {
        return @"SSE";
    } else if (deg > 168.76 && deg <= 191.25) {
        return @"S";
    } else if (deg > 191.25 && deg <= 213.75) {
        return @"SSW";
    } else if (deg > 213.75 && deg <= 236.25) {
        return @"SW";
    } else if (deg > 236.25 && deg <= 258.75) {
        return @"WSW";
    } else if (deg > 258.75 && deg <= 281.25) {
        return @"W";
    } else if (deg > 281.25 && deg <= 303.75) {
        return @"WNW";
    } else if (deg > 303.75 && deg <= 326.25) {
        return @"NW";
    } else if (deg > 326.25 && deg <= 348.75) {
        return @"NNW";
    }
    
    return nil;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *day = [dateFormatter stringFromDate:date];
    int dayNumber = [day integerValue] % 10;

    NSString *daySuffix = nil;
    if (dayNumber == 1) {
        daySuffix = @"st";
    } else if (dayNumber == 2) {
        daySuffix = @"nd";
    } else if (dayNumber == 3) {
        daySuffix = @"rd";
    } else {
        daySuffix = @"th";
    }
    
    dateFormatter.dateFormat = @"EEEE";
    NSMutableString *dayOfWeek = [[[dateFormatter stringFromDate:date] substringWithRange:NSMakeRange(0, 3)] mutableCopy];
    [dayOfWeek appendString:@"."];
    
    NSArray *months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    dateFormatter.dateFormat = @"MM";
    NSString *month = [months objectAtIndex:[[dateFormatter stringFromDate:date] integerValue]];
    
    dateFormatter.dateFormat = @"yyyy";
    NSString *year = [dateFormatter stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@, %@%@ %@ %@", dayOfWeek, day, daySuffix, month, year];
}

- (NSString *)hourFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    
    return [formatter stringFromDate:date];
}

- (NSString *)timeOfDayForIcon:(NSString *)icon
{
    return [icon substringWithRange:NSMakeRange([icon length] - 1, 1)];
}

- (NSDictionary *)signsDictionaryForTimeOfDay:(NSString *)timeOfDay
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *signsDictionaryPath = nil;
    if ([timeOfDay isEqualToString:@"d"]) {
        signsDictionaryPath = [bundle pathForResource:@"Weather-day-images" ofType:@"plist"];
    } else {
        signsDictionaryPath = [bundle pathForResource:@"Weather-night-images" ofType:@"plist"];
    }
    
    return [[NSDictionary alloc] initWithContentsOfFile:signsDictionaryPath];
}

- (BOOL)shouldUpdateWeather:(ObservedCity *)city
{
    NSDate *dateNow = [NSDate date];
    NSDate *updateDate = city.weatherConditions.date;
    
    NSDateComponents *offset = [NSDateComponents new];
    offset.hour = 0;
    offset.minute = -10;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [calendar dateByAddingComponents:offset toDate:dateNow options:0];
    
    NSComparisonResult comparison = [date compare:updateDate];
    if (comparison == NSOrderedDescending) {
        NSLog(@"Should update.");
        return YES;
    }
    
    NSLog(@"Shouldnt' update.");
    return NO;
}

@end
