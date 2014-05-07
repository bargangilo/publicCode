//
//  ADKViewController.h
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADKPhotoDataModel.h"

@interface ADKViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *pictureToBeAnalyzed;
@property (weak, nonatomic) IBOutlet UIView *imageColorOne;
@property (weak, nonatomic) IBOutlet UIView *imageColorTwo;
@property (weak, nonatomic) IBOutlet UIView *imageColorThree;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorOne;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorTwo;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorThree;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorFour;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorFive;
@property (weak, nonatomic) IBOutlet UIView *complementaryColorSix;
@property (strong) ADKPhotoDataModel *photoDataModel;
@property (weak, nonatomic) IBOutlet UILabel *colorRelationLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)colorRelation:(UIBarButtonItem *)sender;

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender;

- (IBAction)colorTap:(UITapGestureRecognizer *)sender;

- (void)kMean:(UIImage*)image;

- (void)splitComplement;

- (void)analogous;

- (void)monochromatic;

- (void)complement;

- (void)triadic;

@end
