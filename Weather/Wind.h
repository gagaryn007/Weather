//
//  WindInfo.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 25.01.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wind : NSObject

@property (nonatomic, strong) NSNumber *deg;
@property (nonatomic, strong) NSNumber *speed;

- (id) initWithNSJSONDictionary:(NSDictionary *)dictionary;

@end
