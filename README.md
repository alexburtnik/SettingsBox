# SettingsBox

[![CI Status](http://img.shields.io/travis/Alex Burtnik/SettingsBox.svg?style=flat)](https://travis-ci.org/Alex Burtnik/SettingsBox)
[![Version](https://img.shields.io/cocoapods/v/SettingsBox.svg?style=flat)](http://cocoapods.org/pods/SettingsBox)
[![License](https://img.shields.io/cocoapods/l/SettingsBox.svg?style=flat)](http://cocoapods.org/pods/SettingsBox)
[![Platform](https://img.shields.io/cocoapods/p/SettingsBox.svg?style=flat)](http://cocoapods.org/pods/SettingsBox)

SettingsBox is a convenient way to save your app settings (primitives and objects) and get them automatically restored when the app launches next time.

## NSUserDefaults approach

Imagine you want to implement a convenient class to store some app’s settings and restore them at the next launch:

```objective-c
//MySettings.h
@interface MySettings : NSObject
@property (nonatomic, assign) BOOL tutorialShown;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSArray *selectedCities;
+ (instancetype)sharedSettings;
@end
```
It’s a common practice to use NSUserDefaults for this purpose, but in order to save and restore values automatically you’ll need to implement a bunch of code:

```objective-c
//MySettings.m
static NSString *kTutorialShownKey = @"kTutorialShownKey";
static NSString *kUserTokenKey = @"kUserTokenKey";
static NSString *kSelectedCitiesKey = @"kSelectedCitiesKey";
static dispatch_once_t onceToken;

@implementation MySettings

+ (instancetype)sharedSettings {
static MySettings *settings = nil;
dispatch_once(&onceToken, ^{
settings = (MySettings *)[super new];
[settings loadSettings];
});
return settings;
}

#pragma mark Setters
- (void) setTutorialShown: (BOOL) tutorialShown {
_tutorialShown = tutorialShown;
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
[userDefaults setBool:_tutorialShown forKey:kTutorialShownKey];
[userDefaults synchronize];
}

- (void) setUserToken: (NSString *) userToken {
_userToken = userToken;
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
[userDefaults setObject:userToken forKey:kUserTokenKey];
[userDefaults synchronize];
}

- (void) setSelectedCities: (NSArray *) selectedCities {
_selectedCities = selectedCities;
NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
[userDefaults setObject:_selectedCities forKey:kSelectedCitiesKey];
[userDefaults synchronize];
}

- (void) loadSettings {
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
[defaults synchronize];
_tutorialShown = [defaults boolForKey:kTutorialShownKey];
_userToken = [defaults objectForKey:kUserTokenKey];
_selectedCities = [defaults objectForKey:kSelectedCitiesKey];
}
```
So for each property you will have to:
* define a key, which will be used for saving and restoring value via NSUserDefaults
* override setter method and save the value to NSUserDefaults in your implementation
* restore value in loadSettings method

## How to use
Let’s see what we have with **SettingsBox**:

```objective-c
@interface MySettings : SettingsBox
@property (nonatomic, assign) BOOL tutorialWasShown;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSArray *selectedCities;
@end
```
Yes, all you have to do is to subclass from SettingsBox and all your properties will get automatically restored at subsequent launches. Isn’t it magic? Let’s look how it works.

## Under the hood
* SettingsBox takes advantage of obj-c runtime to track any property you add to your subclass.
* Values are saved into NSUserDefaults using a key based on the property name.
* KVO is used to autosave every value whenever a corresponding setter is called

## Podfile

SettingsBox is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SettingsBox"
```

## Features
```objective-c
@property (nonatomic, assign) BOOL disableAutoSave;
```
By default every time a setter is called, a new value is saved into NSUserDefaults. However you can disable this behavior and save manually whenever it’s needed
```objective-c
@property (nonatomic, strong) NSMutableSet *excludedAutoSaveProperties;
```
Put any property names in this set and saving to NSUserDefaults will be omitted when setters of corresponding properties are called. This setting is ignored when disableAutoSave is true.
```objective-c
@property (nonatomic, strong) NSMutableSet *excludedProperties;
```
Any properties names from this set are ignored whenever saving is performed (either automatic or manual). This may be handy if you don’t want some properties to be tracked by SettingsBox.
```objective-c
- (void)saveSettings;
```
This method should be called any time you are done with mutating objects, which are stored in your properties. Automatic save is performed when a property is set but not when existing objects are mutated.

## Other notes

* Please note that if you rename a property of your subclass after it’s value had been saved, they will not be restored next time. This limitation is caused by the fact that the keys for NSUserDefaults include property names.
* You can have as many subclasses of SettingsBox as you wish, their values will not conflict even if the same property names are used
* It is not recommended to save huge amount of data in SettingsBox subclasses, however you can save UIImage instances in the same way.
* Mutable instances are restored as mutable, unlike NSUserDefaults, which always restores immutable copies

## Future Enhancements
* Tests for all common classes will be written soon.
* resetSettings & excludedResetProperties implementation

## Author

Alex Burtnik, alexburtnik@gmail.com

## License

SettingsBox is available under the MIT license. See the LICENSE file for more info.
