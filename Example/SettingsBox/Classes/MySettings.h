//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsBox.h"

@class Person;


#define mySettings [MySettings defaultSettings]

@interface MySettings : SettingsBox

@property (nonatomic, assign) BOOL boolProperty;
@property (nonatomic, assign) NSInteger integerProperty;
@property (nonatomic, assign) double doubleProperty;
@property (nonatomic, assign) float floatProperty;

@property (nonatomic, strong) NSNumber *numberProperty;
@property (nonatomic, strong) NSString *stringProperty;

@property (nonatomic, strong) NSMutableArray *arrayOfStrings;
@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, strong) Person *person;

@end