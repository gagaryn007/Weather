//
//  LikeParser.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 02.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "LikeParser.h"
#import "ObservedCity.h"

@implementation LikeParser

- (void)parseNSJSONDictionary:(NSDictionary *)dictionary withDelegate:(id<WeatherConnectionDelegate>)delegate
{
    NSMutableArray *cityList = [[NSMutableArray alloc] init];
    NSArray *cityJsonList = [dictionary objectForKey:@"list"];
    for (NSDictionary *tmpDictionary in cityJsonList) {
        ObservedCity *city = [[ObservedCity alloc] initWithNSJSONDictionary:tmpDictionary];
        [cityList addObject:city];
    }
    
    [delegate likeConnectionDidFinishedWithSucces:cityList];
}

@end
