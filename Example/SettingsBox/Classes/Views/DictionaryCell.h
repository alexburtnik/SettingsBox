//
//  DictionaryCell.h
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 6/1/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictionaryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@end
