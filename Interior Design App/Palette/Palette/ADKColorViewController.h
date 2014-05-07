//
//  ADKColorViewController.h
//  Palette
//
//  Created by Donovan King on 4/13/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADKColorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *cValue;
@property (weak, nonatomic) IBOutlet UILabel *mValue;
@property (weak, nonatomic) IBOutlet UILabel *yValue;
@property (weak, nonatomic) IBOutlet UILabel *kValue;
@property(strong) UIColor *color; 
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
@property (weak, nonatomic) IBOutlet UILabel *colorName;
- (IBAction)captureClick:(UIButton *)sender;

@end
