//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

typedef NS_ENUM (NSInteger, Gender) {
    GenderFemale = 0,
    GenderMale = 1
};

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) BOOL isMarried;
@property (nonatomic, strong) UIImage *image;

@end