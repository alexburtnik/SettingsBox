//
//  SettingsBox.m
//  SettingsBox
//
//  Created by Alex Burtnik on 5/28/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "SettingsBox.h"
#import "NSObject+SettingsBox.h"

static dispatch_once_t onceToken;

@implementation SettingsBox

+ (instancetype)defaultSettings {
    static SettingsBox *settings = nil;
    dispatch_once(&onceToken, ^{
        settings = (SettingsBox *)[super new];
    });
    return settings;
}

- (instancetype) init {
    if (self = [super init]) {
        [self savePropertyClasses];
        [self loadSettings];
        for (NSString *propertyName in self.allPropertiesNames)
            [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew context:nil];
        if (!self.excludedProperties)
            self.excludedProperties = [NSMutableSet set];
        if (!self.excludedAutoSaveProperties)
            self.excludedAutoSaveProperties = [NSMutableSet set];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!_disableAutoSave && ![self.excludedAutoSaveProperties containsObject:keyPath]) {
        [self saveProperty:keyPath];
    }
}

#pragma mark Save & Load

- (void)saveSettings {
    for (NSString *propertyName in self.propertiesToSave) {
        [self saveProperty:propertyName];
    }
}

- (void) loadSettings {
    for (NSString *propertyName in self.allPropertiesNames) {
        [self loadProperty:propertyName];
    }
}

- (NSArray *) propertiesToSave {
    NSMutableArray *result = [[self allPropertiesNames] mutableCopy];
    for (NSString *excludedProperty in self.excludedProperties)
        [result removeObject:excludedProperty];
    return result;
}

- (void)saveProperty: (NSString *) propertyName {
    if ([self respondsToSelector:NSSelectorFromString(propertyName)]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        Class propertyClass = [self loadClassForProperty:propertyName];
        NSString *key = [self userDefaultsKeyForProperty:propertyName];
        NSObject *value = [self valueForKey:propertyName];
        if (!propertyClass || [propertyClass isClassPlistCompatible]) {
            [defaults setObject:value forKey:key];
        }
        else {
            NSData *encodedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
            [defaults setObject:encodedValue forKey:key];
        }
        [defaults synchronize];
    }
}

- (void) loadProperty: (NSString *) propertyName {
    if ([self respondsToSelector:[self.class setterForPropertyNamed:propertyName]]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];

        Class propertyClass = [self loadClassForProperty:propertyName];
        NSString *key = [self userDefaultsKeyForProperty:propertyName];
        NSObject *value = [defaults objectForKey:key];
        if ([propertyClass isClassMutable]) {
            value = [value mutableCopy];
        }
        if (propertyClass && ![propertyClass isClassPlistCompatible] && [value isKindOfClass:[NSData class]]) {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *) value];
        }
        if (value)
            [self setValue:value forKey:propertyName];
    }
}

#pragma Storing classes

- (void)savePropertyClasses {
    for (NSString *propertyName in self.allPropertiesNames) {

        Class propertyClass = [self classOfPropertyNamed:propertyName];
        [self saveClass:propertyClass forProperty:propertyName];
    }
}

- (void)saveClass:(Class)someClass forProperty: (NSString *) propertyName {
    NSString *classString = NSStringFromClass(someClass);
    NSString *key = [self userDefaultsKeyForClassOfProperty:propertyName];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:classString forKey:key];
    [defaults synchronize];
}

- (Class)loadClassForProperty: (NSString *) propertyName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *key = [self userDefaultsKeyForClassOfProperty:propertyName];
    NSString *classString = [defaults objectForKey:key];
    return NSClassFromString(classString);
}

#pragma mark NSUserDefaults keys

- (NSString *)userDefaultsPrefix {
    return [NSString stringWithFormat:@"SettingsBox:%@:", NSStringFromClass([self class])];
}

- (NSString *)userDefaultsKeyForProperty: (NSString *) propertyName {
    return [self.userDefaultsPrefix stringByAppendingString:propertyName];
}

- (NSString *)userDefaultsKeyForClassOfProperty: (NSString *) propertyName {
    return [self.userDefaultsPrefix stringByAppendingFormat:@"PropertyClass:%@", propertyName];
}

@end