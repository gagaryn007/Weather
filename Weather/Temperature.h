//
//  Temperature.h
//  Weather
//
//  Created by Bartłomiej Oziębło on 06.02.2014.
//  Copyright (c) 2014 Bartłomiej Oziębło. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Temperature : NSObject

@property (strong, nonatomic) NSNumber *day;
@property (strong, nonatomic) NSNumber *eve;
@property (strong, nonatomic) NSNumber *temp;
@property (strong, nonatomic) NSNumber *temp_max;
@property (strong, nonatomic) NSNumber *temp_min;
@property (strong, nonatomic) NSNumber *morn;
@property (strong, nonatomic) NSNumber *night;

- (id)initWithNSJSONDictionary:(NSDictionary *)dictionary;

@end
