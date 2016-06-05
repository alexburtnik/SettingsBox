//
//  MainViewController.m
//  SettingsBoxExample
//
//  Created by Alex Burtnik on 5/31/16.
//  Copyright © 2016 Alex Burtnik. All rights reserved.
//

#import "MainViewController.h"
#import "MySettings.h"
#import "UIColor+Additions.h"

@interface MainViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *boolSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *integerSegmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *doubleValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *doubleSlider;

@property (weak, nonatomic) IBOutlet UILabel *numberValueLabel;
@property (weak, nonatomic) IBOutlet UIStepper *numberStepper;

@property (weak, nonatomic) IBOutlet UITextField *stringTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI{
    [self setBool:mySettings.boolProperty];
    [self setInteger:mySettings.integerProperty];
    [self setDouble:mySettings.doubleProperty];
    [self setNumber:mySettings.numberProperty];
    [self setString:mySettings.stringProperty];
}

#pragma mark Accessors

- (void) setBool: (BOOL) boolValue {
    [_boolSwitch setOn:boolValue animated:NO];
}

- (void) setInteger: (NSInteger) intValue {
    _integerSegmentedControl.selectedSegmentIndex = intValue;
}

- (void) setDouble: (double) doubleValue {
    _doubleValueLabel.text = [NSString stringWithFormat:@"%.2f", doubleValue];
    _doubleSlider.value = (float)mySettings.doubleProperty;
}

- (void) setNumber: (NSNumber *) numberValue {
    _numberValueLabel.text = [NSString stringWithFormat:@"%d", [numberValue intValue]];
    [_numberStepper setValue:[mySettings.numberProperty integerValue]];
}

- (void) setString: (NSString *) stringValue {
    _stringTextField.text = stringValue;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UIView *selectionView = [[UIView alloc] initWithFrame:cell.bounds];
    selectionView.backgroundColor = [[UIColor sb_beigeColor] colorWithAlphaComponent:0.5];
    cell.selectedBackgroundView = selectionView;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Actions

- (IBAction)boolSwitchValueChanged:(UISwitch *)sender {
    mySettings.boolProperty = sender.on;
    [self setBool:mySettings.boolProperty];
}

- (IBAction)integerSegmentedControlValueChanged:(UISegmentedControl *)sender {
    mySettings.integerProperty = (NSInteger)sender.selectedSegmentIndex;
    [self setInteger:mySettings.integerProperty];
}

- (IBAction)doubleSliderValueChanged:(UISlider *)sender {
    mySettings.doubleProperty = sender.value;
    [self setDouble:mySettings.doubleProperty];
}

- (IBAction)numberStepperValueChanged:(UIStepper *)sender {
    mySettings.numberProperty = @((NSInteger)sender.value);
    [self setNumber:mySettings.numberProperty];
}

#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    mySettings.stringProperty = newString;
    [self setString:newString];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Helpers


@end
