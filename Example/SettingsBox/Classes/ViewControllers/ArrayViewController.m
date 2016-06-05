//
//  ArrayViewController.m
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 5/31/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "ArrayViewController.h"
#import "MySettings.h"
#import "ArrayCell.h"

@interface ArrayViewController () <UITextFieldDelegate>

@end

@implementation ArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (!mySettings.arrayOfStrings)
        mySettings.arrayOfStrings = [NSMutableArray array];
}

#pragma mark Actions

- (IBAction)newButtonPressed {
    [mySettings.arrayOfStrings addObject:@""];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mySettings.arrayOfStrings.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.view endEditing:YES];
    [super setEditing:editing animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mySettings.arrayOfStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArrayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArrayCellIdentifier" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld.", (long)indexPath.row+1];
    cell.textField.text = mySettings.arrayOfStrings[(NSUInteger)indexPath.row];
    cell.textField.tag = indexPath.row;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *stringToMove = mySettings.arrayOfStrings[sourceIndexPath.row];
    [tableView beginUpdates];
    [mySettings.arrayOfStrings removeObjectAtIndex:sourceIndexPath.row];
    [mySettings.arrayOfStrings insertObject:stringToMove atIndex:destinationIndexPath.row];
    [tableView endUpdates];
    [mySettings saveSettings];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = (NSUInteger) indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [mySettings.arrayOfStrings removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self updateVisibleCells];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [mySettings.arrayOfStrings insertObject:@"" atIndex:row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void) updateVisibleCells {
    for (ArrayCell *cell in self.tableView.visibleCells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        cell.titleLabel.text = [NSString stringWithFormat:@"%ld.", (long)indexPath.row+1];
    }
}

#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger index = (NSUInteger) textField.tag;
    if (index < mySettings.arrayOfStrings.count) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        mySettings.arrayOfStrings[index] = newString;
        [mySettings saveSettings];
    }
    return YES;
}

@end
