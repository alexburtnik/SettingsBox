//
//  SettingsBox.h
//  SettingsBox
//
//  Created by Alex Burtnik on 5/28/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsBox : NSObject

/**
By default every time a setter is called, a new value is saved into NSUserDefaults. However you can disable this behavior and save manually whenever it’s needed
 */
@property (nonatomic, assign) BOOL disableAutoSave;

/**
 Put property names in this set and saving to NSUserDefaults will be omitted when setters of corresponding properties are called. These values are ignored when "disableAutoSave" is set.
 */
@property (nonatomic, strong) NSMutableSet *excludedAutoSaveProperties;

/**
 All property names from "excludedProperties" set are ignored whenever saving is performed (either automatic or manual). This may be handy if you don’t want some properties to be tracked by SettingsBox.
 */
@property (nonatomic, strong) NSMutableSet *excludedProperties;

+ (instancetype) defaultSettings;

/**
 This method should be called any time you are done with changing nested properties. Automatic save is not performed when existing objects are being mutated
 */
- (void)saveSettings;

@end
