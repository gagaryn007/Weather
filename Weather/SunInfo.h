//
//  SunInfo.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 26.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SunInfo : NSObject

@property (nonatomic, strong) NSDate *sunset;
@property (nonatomic, strong) NSDate *sunrise;

- (id) initWithNSJSONDictionary:(NSDictionary *)dictionary;

@end
