//
// Created by Alex Burtnik on 5/29/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "Person.h"


@implementation Person

- (NSString *)description {
    return [NSString stringWithFormat:@"Person: %@, %@, %ld y.o., %@, height: %.1f",
    _name, self.genderString, (long)_age, self.marriageString, _height ];
}

- (NSString *) genderString {
    switch (_gender) {
        case GenderMale: return @"Male";
        case GenderFemale: return @"Female";
        default: return @"";
    }
}

- (NSString *) marriageString {
    return _isMarried ? @"Married" : @"Single";
}

@end