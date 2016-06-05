//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "MySettings.h"
#import "Person.h"

@implementation MySettings

- (instancetype) init {
    if (self = [super init]) {
//        [self.excludedAutoSaveProperties addObject:@"doubleProperty"];
    }
    return self;
}

- (NSString *)description {
    NSString *boolString = _boolProperty ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"\ninteger: %li;\nbool: %@;\ndouble: %.2f;\nfloat: %.2f;\nnumber: %@;\nstring: %@;\narray: %@\nobject: %@",
            (long)_integerProperty, boolString, _doubleProperty, _floatProperty, _numberProperty, _stringProperty, _arrayOfStrings, _person];
}


@end