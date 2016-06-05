//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SettingsBox)

#pragma mark Property helpers
- (NSArray *)allPropertiesNames;
- (Class)classOfPropertyNamed:(NSString *)propertyName;
+ (SEL)setterForPropertyNamed:(NSString *)propertyName;

#pragma mark Plist helpers
+ (BOOL)isClassPlistCompatible;
+ (BOOL)isClassMutable;

@end
