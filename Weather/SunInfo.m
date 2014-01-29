//
//  SunInfo.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "SunInfo.h"

@implementation SunInfo

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSTimeInterval sunrise = [[dictionary objectForKey:@"sunrise"] integerValue];
        NSTimeInterval sunset = [[dictionary objectForKey:@"sunset"] integerValue];
        
        self.sunrise = [NSDate dateWithTimeIntervalSince1970:sunrise];
        self.sunset = [NSDate dateWithTimeIntervalSince1970:sunset];
    }
    return self;
}

@end
