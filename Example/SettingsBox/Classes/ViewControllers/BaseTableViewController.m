//
//  BaseTableViewController.m
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 5/31/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}

@end
