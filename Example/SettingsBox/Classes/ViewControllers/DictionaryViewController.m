//
//  DictionaryViewController.m
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 6/1/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "DictionaryViewController.h"
#import "DictionaryCell.h"
#import "MySettings.h"
#import "UIBarButtonItem+Additions.h"

@interface DictionaryViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *keysArray;
@property (nonatomic, strong) NSMutableArray *valuesArray;

@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self restore];
    [self createNavButtons];
}

- (void) createNavButtons {
    UIImage *saveImage = [UIImage imageNamed:@"ic_check"];
    UIBarButtonItem *saveButtonItem = [UIBarButtonItem buttonItemWithImage:saveImage target:self action:@selector(savePressed)];
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, saveButtonItem];
}

- (void) savePressed {
    if ([self save])
        [self.navigationController popViewControllerAnimated:YES];
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                   message:@"All keys must be unique"
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil] show];
    }
}

- (BOOL) save {
    if (self.keysAreUnique && self.dataSourceIsValid) {
        mySettings.dictionary = self.dictionaryRepresentation;
        return YES;
    }
    return NO;
}

- (void) restore {
    self.keysArray = [NSMutableArray array];
    self.valuesArray = [NSMutableArray array];
    [mySettings.dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL *stop) {
        [_keysArray addObject:key];
        [_valuesArray addObject:value];
    }];
}

- (IBAction)newButtonPressed {
    [self addEntry];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_keysArray.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (BOOL) keysAreUnique {
    NSSet *keysSet = [NSSet setWithArray:_keysArray];
    return _keysArray.count == keysSet.count;
}

- (BOOL) dataSourceIsValid {
    return _keysArray.count == _valuesArray.count;
}

- (NSDictionary *) dictionaryRepresentation {
    if (self.dataSourceIsValid) {
        NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:_keysArray.count];
        [_keysArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            result[key] = _valuesArray[idx];
        }];
        return result;
    }
    return nil;
}

#pragma mark Actions

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.view endEditing:YES];
    [super setEditing:editing animated:animated];
}


#pragma mark UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _keysArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DictionaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DictionaryCellIdentifier" forIndexPath:indexPath];

    NSUInteger row = (NSUInteger) indexPath.row;

    cell.keyTextField.text = _keysArray[row];
    cell.valueTextField.text = _valuesArray[row];

    cell.keyTextField.tag = row*2;
    cell.valueTextField.tag = row*2 + 1;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = (NSUInteger) indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeEntryAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self insertEntryWithKey:@"" value:@"" atIndex:row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark UITableView delegate

#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger index = (NSUInteger)(textField.tag/2);
    if (textField.tag % 2 == 0)
        _keysArray[index] = newText;
    else
        _valuesArray[index] = newText;
    return YES;
}

#pragma mark Helpers

- (void) removeEntryAtIndex: (NSUInteger) index {
    [_keysArray removeObjectAtIndex:index];
    [_valuesArray removeObjectAtIndex:index];
}

- (void) insertEntryWithKey: (NSString *) key value: (NSString *) value atIndex: (NSUInteger) index {
    [_keysArray insertObject:key atIndex:index];
    [_valuesArray insertObject:value atIndex:index];
}

- (void) addEntry {
    [_keysArray addObject:@""];
    [_valuesArray addObject: @""];
}

@end
