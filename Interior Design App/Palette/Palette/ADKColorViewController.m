//
//  ADKColorViewController.m
//  Palette
//
//  Created by Donovan King on 4/13/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import "ADKColorViewController.h"
#import "ADKPhotoDataModel.h"

@interface ADKColorViewController ()

@end

@implementation ADKColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     // Do any additional setup after loading the view.
     NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RGB2" ofType:@"txt"];
//
     NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
     float smallestDistance = 10000.0;
     NSInteger index = 0;
     NSMutableArray *titles = [[NSMutableArray alloc] init];
     NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
     for (int i = 0; i< [lines count]; i++) {
         NSArray *components = [lines[i] componentsSeparatedByString:@"		"];
         NSString *cleanedString = @"";
         if ([components[1] length] > 0) {
             cleanedString = [components[1] substringToIndex:[components[1] length] - 1];
         }
         [titles addObject:cleanedString];
         NSArray *RGB = [components[0] componentsSeparatedByString:@" "];
         float r = [RGB[0] floatValue]/255.0;
         float g = [RGB[1] floatValue]/255.0;
         float b = [RGB[2] floatValue]/255.0;
         
         UIColor *currentColor = [[UIColor alloc] initWithRed:r green:g blue:b alpha:1.0];
         ADKPhotoDataModel *calculator = [[ADKPhotoDataModel alloc] init];
         float distance = [calculator calculateEuclideanDistanceBetweenColorA:currentColor andColorB:self.color];
         
         if (distance < smallestDistance) {
             smallestDistance = distance;
             //update the label with the color
             index = i;
         }
     }
     self.view.backgroundColor = self.color;
    CGFloat r, g, b, k;
    r = 0;
    g = 0;
    b = 1.0;
    
//    Black   = minimum(1-Red,1-Green,1-Blue)
//    Cyan    = (1-Red-Black)/(1-Black)
//    Magenta = (1-Green-Black)/(1-Black)
//    Yellow  = (1-Blue-Black)/(1-Black)
    
    [self.color getRed:&r green:&g blue:&b alpha:nil];
    r*=255.0;
    g*=255.0;
    b*=255.0;
    
    k = MIN((255.0-r), MIN((255.0-g), (255.0-b)));
    self.cValue.text = [NSString stringWithFormat:@"C: %.2f", ((1-r-k)/(1-k))];
    self.mValue.text = [NSString stringWithFormat:@"M: %.2f", ((1-g-k)/(1-k))];
    self.yValue.text = [NSString stringWithFormat:@"Y: %.2f", ((1-b-k)/(1-k))];
    self.kValue.text = [NSString stringWithFormat:@"K: %.2f", k];
    self.rValue.text = [NSString stringWithFormat:@"R: %.2f", r];
    self.gValue.text = [NSString stringWithFormat:@"G: %.2f", g];
    self.bValue.text = [NSString stringWithFormat:@"B: %.2f", b];
    self.title = titles[index];
    self.colorName.text = titles[index];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)captureClick:(UIButton *)sender {
    self.colorName.hidden = NO;
    sender.hidden = YES;

    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //[imageData writeToFile: atomically:YES];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    self.colorName.hidden = YES;
    sender.hidden = NO; 
}
@end
