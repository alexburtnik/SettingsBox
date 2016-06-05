//
// Created by Alex Burtnik on 6/4/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)imageByCroppingToSquare;

- (UIImage *)imageWithSize:(CGSize)newSize scale:(CGFloat)scale;

- (UIImage *)imageWithSize:(CGSize)newSize;



@end