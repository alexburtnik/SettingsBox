//
//  AppDelegate.m
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 5/29/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "AppDelegate.h"
#import "MySettings.h"
#import "Person.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [MySettings defaultSettings];
    return YES;
}

@end
