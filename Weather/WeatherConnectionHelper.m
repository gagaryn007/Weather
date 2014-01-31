//
//  WeatherConnectionHelper.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "WeatherConnectionHelper.h"

@interface WeatherConnectionHelper()

@property (nonatomic) BOOL explicit;
@property (nonatomic) BOOL forecast;

@property (strong, nonatomic) NSMutableData *receivedData;

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

    NSString *msgError = [jsonResultDict objectForKey:@"message"];
    if (msgError != nil && ![msgError isEqual:@"like"]) {
        if (self.delegate != nil) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(msgError, nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(msgError, nil),
                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Enter proper city name or give up", nil)};
            
            NSError *error = [NSError errorWithDomain:@"Weather" code:-69 userInfo:userInfo];
            [self.delegate didFailWithError:error];
        }
        return;
    }
    
    if (self.explicit && !self.forecast) {
        ObservedCity *city = [[ObservedCity alloc] initWithNSJSONDictionary:jsonResultDict];
        if (self.delegate != nil) {
            [self.delegate explicitConnectionDidFinishedWithSucces:city];
        }
    } else if (!self.explicit && !self.forecast) {
        NSMutableArray *cityList = [[NSMutableArray alloc] init];
        NSArray *cityJsonList = [jsonResultDict objectForKey:@"list"];
        for (NSDictionary *dictionary in cityJsonList) {
            ObservedCity *city = [[ObservedCity alloc] initWithNSJSONDictionary:dictionary];
            [cityList addObject:city];
        }
        
        if (self.delegate != nil) {
            [self.delegate likeConnectionDidFinishedWithSucces:cityList];
        }
    } else if (self.explicit && self.forecast) {
        NSLog(@"POZDRO");
        [self.delegate explicitConnectionDidFinishedWithSucces:jsonResultDict];
    }
}

#pragma mark - WeatherConnectionHelper

- (void)makeExplicitRequest:(NSNumber *)cityId
{
    self.explicit = YES;
    
    if (cityId == nil) {
        return;
    }
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?id=%@", cityId];
    
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeLikeRequest:(NSString *)city
{
    self.explicit = NO;
    self.forecast = NO;
    
    if (city == nil) {
        return;
    }
    
    NSString *cityForURL = [city stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/find?q=%@&type=like", cityForURL];
    
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeExplicitRequestWithLocations:(double)lat lon:(double)lon
{
    self.explicit = YES;
    self.forecast = NO;
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%lf&lon=%lf", lat, lon];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)makeForecastRequest:(NSNumber *)cityId
{
    self.explicit = YES;
    self.forecast = YES;
    
    NSString *query = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?id=%@&cnt=7", cityId];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

@end
