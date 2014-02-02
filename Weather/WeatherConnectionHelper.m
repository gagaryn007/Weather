//
//  WeatherConnectionHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherConnectionHelper.h"
#import "ResponseParser.h"
#import "ForecastParser.h"
#import "ExplicitParser.h"
#import "LikeParser.h"

@interface WeatherConnectionHelper()

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) id<ResponseParser> parser;

@end

@implementation WeatherConnectionHelper

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.delegate != nil) {
        [self.delegate didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *jsonResultDict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error != nil) {
        if (self.delegate != nil) {
            [self.delegate didFailWithError:error];
        }
        return;
    }

    NSString *msg = [jsonResultDict objectForKey:@"message"];
    NSString *cod = [jsonResultDict objectForKey:@"cod"];
    if (cod != nil && [cod isEqual:@"404"]) {
        if (self.delegate != nil) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(msg, nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(msg, nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(msg, nil)};
            
            NSError *error = [NSError errorWithDomain:@"Weather" code:404 userInfo:userInfo];
            [self.delegate didFailWithError:error];
        }
        return;
    }
    
    [self.parser parseNSJSONDictionary:jsonResultDict withDelegate:self.delegate];
}

#pragma mark - WeatherConnectionHelper

- (void)makeExplicitRequest:(NSNumber *)cityId
{
    if (cityId == nil) {
        return;
    }
    
    self.parser = [[ExplicitParser alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@", cityId];
    
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeLikeRequest:(NSString *)city
{
    if (city == nil) {
        return;
    }
    
    self.parser = [[LikeParser alloc] init];
    
    NSString *cityForURL = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like", cityForURL];
    
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeExplicitRequestWithLocations:(double)lat lon:(double)lon
{
    self.parser = [[ExplicitParser alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%lf&lon=%lf", lat, lon];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeForecastRequest:(NSNumber *)cityId
{
    self.parser = [[ForecastParser alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&cnt=7", cityId];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

@end
