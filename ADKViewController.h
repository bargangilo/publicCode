//
//  ADKViewController.h
//  Out To Eat
//
//  Created by Donovan King on 4/30/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutToEat.h"

@interface ADKViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timesThisMonth;
@property (weak, nonatomic) IBOutlet UILabel *cashThisMonth;
@property (weak, nonatomic) IBOutlet UITextField *costInput;
@property (strong) UIManagedDocument *document;
@property (strong) OutToEat *loadedData;

- (IBAction)wentOutClicked:(UIButton *)sender;
- (void) setUpNewData;
- (void) loadPrevData;

@end
