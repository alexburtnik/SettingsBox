//
// Created by Alex Burtnik on 6/4/16.
// Copyright (c) 2016 Alex Burtnik. All rights reserved.
//

#import "ProfileViewController.h"
#import "Person.h"
#import "MySettings.h"
#import "UIImage+Additions.h"
#import "UIBarButtonItem+Additions.h"
#import "UIColor+Additions.h"
#import <Photos/Photos.h>

@interface ProfileViewController() <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (weak, nonatomic) IBOutlet UIStepper *ageStepper;
@property (weak, nonatomic) IBOutlet UILabel *ageValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;
@property (weak, nonatomic) IBOutlet UILabel *heightValueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *marriedSwitch;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!mySettings.person) {
        mySettings.person = [Person new];
    }
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem buttonItemWithImage:[UIImage imageNamed:@"ic_check"] target:self action:@selector(savePressed)];
    [self updateUI];
    [self prepareImageView];
}

- (void) prepareImageView {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.bounds = _imageView.bounds;
    circleLayer.position = CGPointMake(circleLayer.bounds.size.width/2, circleLayer.bounds.size.height/2);
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:circleLayer.bounds].CGPath;
    circleLayer.strokeColor = [UIColor sb_brownColor].CGColor;
    circleLayer.lineWidth = 3;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    [_imageView.layer addSublayer:circleLayer];
}

- (void) updateUI {
    [self updateImage];
    [self setName:mySettings.person.name];
    [self setGender:mySettings.person.gender];
    [self setAge:mySettings.person.age];
    [self setMarriage:mySettings.person.isMarried];
    [self setHeight:mySettings.person.height];
}

- (void) updateImage {
    self.imageView.image = mySettings.person.image ?: [UIImage imageNamed:@"avatar_placeholder"];
}

#pragma mark Accessors

- (void) setName: (NSString *) name {
    _nameTextField.text = name;
}

- (void) setGender: (Gender) gender {
    _genderSegmentedControl.selectedSegmentIndex = gender;
}

- (void) setAge: (NSInteger) age {
    _ageStepper.value = age;
    _ageValueLabel.text = [NSString stringWithFormat:@"%ld", age];
}

- (void) setMarriage: (BOOL) married {
    _marriedSwitch.on = married;
}

- (void) setHeight: (float) height {
    _heightSlider.value = height;
    _heightValueLabel.text = [NSString stringWithFormat:@"%.1fcm", height];
}

#pragma mark Actions

- (IBAction) genderValueChanged: (UISegmentedControl *) segmentedControl {
    mySettings.person.gender = (Gender)segmentedControl.selectedSegmentIndex;
    [self setGender:mySettings.person.gender];
    [self.view endEditing:YES];
}
    
- (IBAction)ageValueChanged:(UIStepper *)sender {
    mySettings.person.age = (NSInteger) sender.value;
    [self setAge:mySettings.person.age];
    [self.view endEditing:YES];
}

- (IBAction)heightValueChanged:(UISlider *)sender {
    mySettings.person.height = sender.value;
    [self setHeight:mySettings.person.height];
    [self.view endEditing:YES];
}

- (IBAction)marriageValueChanged:(UISwitch *)sender {
    mySettings.person.isMarried = sender.isOn;
    [self setMarriage:mySettings.person.isMarried];
    [self.view endEditing:YES];
}

- (void) savePressed {
    [mySettings saveSettings];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Avatar picking

- (IBAction)photoButtonPressed {
    PHAuthorizationStatus libraryStatus = [PHPhotoLibrary authorizationStatus];
    switch (libraryStatus) {
        case PHAuthorizationStatusAuthorized:
            [self pickPhotoVideo];
            break;
        case PHAuthorizationStatusDenied:
            [self showPermissionDenied: NSLocalizedString(@"Photos", nil)];
            break;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized)
                    [self pickPhotoVideo];
            }];
        }
        default:
            break;
    }

}

- (void) showPermissionDenied: (NSString *) serviceName {
    NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Please go to iOS Settings and give permissions to", nil), serviceName];
    [[[UIAlertView alloc] initWithTitle:@"Permission denied" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}


- (void) pickPhotoVideo {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.navigationBar.barTintColor = [UIColor sb_brownColor];
    picker.navigationBar.tintColor = [UIColor sb_beigeColor];
    picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor sb_beigeColor]};
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        [self saveImage:info[UIImagePickerControllerOriginalImage]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveImage: (UIImage *) image {
    image = [image imageByCroppingToSquare];
    image = [image imageWithSize:_imageView.bounds.size];
    mySettings.person.image = image;
    [mySettings saveSettings];
    [self updateImage];
}


#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    mySettings.person.name = newString;
    [self setName:newString];
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end