//
//  ColorSelector.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 27.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColorPastelFactory.h"

@interface ColorChooser : NSObject

- (UIColor *)colorForTemperature:(NSNumber *)kelvinTemp andTimeOfDay:(NSString *)timeOfDay;

@end
