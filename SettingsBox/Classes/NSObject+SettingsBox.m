//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "NSObject+SettingsBox.h"
#import <objc/runtime.h>

@implementation NSObject (SettingsBox)

#pragma mark Property helpers

- (NSArray *)allPropertiesNames {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            [result addObject:propertyName];
        }
    }
    free(properties);
    return result;
}

-(Class) classOfPropertyNamed:(NSString*) propertyName {
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        if (splitEncodeType.count > 1) {
            NSString *className = splitEncodeType[1];
            propertyClass = NSClassFromString(className);
        }
    }
    return propertyClass;
}

+ (SEL) setterForPropertyNamed: (NSString *) propertyName {
    if (propertyName.length == 0)
        return nil;
    else {
        NSString *firstLetter = [[propertyName substringToIndex:1] uppercaseString];
        propertyName = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstLetter];
        NSString *setterString = [NSString stringWithFormat:@"set%@:", propertyName];
        return NSSelectorFromString(setterString);
    }
}

#pragma mark Encoding objects

- (void)encodeWithCoder:(NSCoder *)encoder {
    for (NSString* propertyName in self.allPropertiesNames) {
        id value = [self valueForKey:propertyName];
        [encoder encodeObject:value forKey:propertyName];
    }
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if([self init]) {
        for (NSString* key in self.allPropertiesNames) {
            id value = [decoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

#pragma mark Plist helpers

+ (BOOL)isClassPlistCompatible {
    NSSet *plistClasses = [NSSet setWithObjects:[NSString class], [NSData class],
                                                [NSArray class], [NSMutableArray class],
                                                [NSDictionary class], [NSMutableDictionary class],
                                                [NSDate class],
                                                [NSNumber class], nil];
    return [plistClasses containsObject:self.class];
}

+ (BOOL) isClassMutable {
    NSSet *mutablePlistClasses = [NSSet setWithObjects:
            [NSMutableString class],
            [NSMutableArray class],
            [NSMutableDictionary class],
            [NSMutableData class],
            [NSMutableSet class],
            [NSMutableAttributedString class],
            [NSMutableCharacterSet class],
            [NSMutableIndexSet class],
            [NSMutableOrderedSet class],
            [NSMutableURLRequest class], nil];
    return [mutablePlistClasses containsObject:self.class];
}


@end