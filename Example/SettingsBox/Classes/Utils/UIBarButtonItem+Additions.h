//
// Created by Alex Burtnik on 6/4/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Additions)

+ (UIBarButtonItem *)buttonItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end