//
//  UIColorFactory.m
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import "UIColorPastelFactory.h"

@implementation UIColorPastelFactory

- (UIColor *) colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    red /= 255.0;
    green /= 255.0;
    blue /= 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (UIColor *)yellow
{
    return [self colorWithRed:244 green:228 blue:83];
}

- (UIColor *)orange
{
    return [self colorWithRed:237 green:127 blue:68];
}

- (UIColor *)lightGreen
{
    return [self colorWithRed:169 green:219 blue:122];
}

- (UIColor *)red
{
    return [self colorWithRed:182 green:48 blue:37];
}

- (UIColor *)blue
{
    return [self colorWithRed:43 green:139 blue:233];
}

- (UIColor *)coldBlue
{
    return [self colorWithRed:128 green:180 blue:208];
}

- (UIColor *)arcticBlue
{
    return [self colorWithRed:154 green:209 blue:207];
}

- (UIColor *)violet
{
    return [self colorWithRed:48 green:39 blue:53];
}

- (UIColor *)grey
{
    return [self colorWithRed:150 green:162 blue:177];
}

@end
