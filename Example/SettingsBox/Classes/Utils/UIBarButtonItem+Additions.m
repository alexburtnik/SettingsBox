//
// Created by Alex Burtnik on 6/4/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "UIBarButtonItem+Additions.h"


@implementation UIBarButtonItem (Additions)

+ (UIBarButtonItem *)buttonItemWithImage:(UIImage *)image target:(id)target action: (SEL) action {
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:image forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:saveButton];
}


@end