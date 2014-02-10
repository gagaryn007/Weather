//
//  ColorSelector.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "ColorChooser.h"

@implementation ColorChooser

- (UIColor *)colorForTemperature:(NSNumber *)kelvinTemp andTimeOfDay:(NSString *)timeOfDay
{
    UIColorPastelFactory *colorFactory = [[UIColorPastelFactory alloc] init];
    double temp = [kelvinTemp doubleValue] - 273.15;
    if ([timeOfDay isEqualToString:@"d"]) {
        if (temp <= -15) {
            return [colorFactory arcticBlue];
        } else if (temp > -15 && temp <= -5) {
            return [colorFactory coldBlue];
        } else if (temp > -5 && temp <= 5) {
            return [colorFactory blue];
        } else if (temp > 5 && temp <= 15) {
            return [colorFactory lightGreen];
        } else if (temp > 15 && temp <= 20) {
            return [colorFactory yellow];
        } else if (temp > 20 && temp <= 27) {
            return [colorFactory orange];
        } else if (temp > 27) {
            return [colorFactory red];
        }
    } else if ([timeOfDay isEqualToString:@"n"]) {
        if (temp <= 0) {
            return [colorFactory violet];
        } else if (temp > 0) {
            return [colorFactory grey];
        }
    }
    
    return nil;
}

@end