//
//  ADKViewController.m
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import "ADKViewController.h"
#import "ADKPhotoDataModel.h"
#import "ADKColorCluster.h"
#import "ADKColorViewController.h"

#define K 8
#define MIN_MOVE_DISTANCE 0.15


@interface ADKViewController ()

- (void)takePicture;
- (void)selectPicture;


@end

@implementation ADKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    self.photoDataModel = [[ADKPhotoDataModel alloc] init];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(colorTap:)];
    [self.tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
//    [self.imageColorOne addGestureRecognizer:self.tapGestureRecognizer];
//    [self.imageColorTwo addGestureRecognizer:self.tapGestureRecognizer];
//    [self.imageColorThree addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorOne addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorTwo addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorThree addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorFour addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorFive addGestureRecognizer:self.tapGestureRecognizer];
//    [self.complementaryColorSix addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select Photo", nil];
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
    
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
//    if ([touch.view isKindOfClass:[UIToolbar class]]) {
//        return NO;
//    }
    if ([touch.view.superview isKindOfClass:[UIToolbar class]]) return NO;
    return YES;
}

- (IBAction)colorTap:(UITapGestureRecognizer *)sender {
    NSArray* viewArray = @[self.imageColorOne, self.imageColorTwo, self.imageColorThree, self.complementaryColorOne, self.complementaryColorTwo, self.complementaryColorThree, self.complementaryColorFour, self.complementaryColorFive, self.complementaryColorSix];

    for (int i = 0; i < 9; i++) {
        UIView* currentView = viewArray[i];
        CGPoint location = [sender locationInView:currentView];
        
        if (!((location.x < 0) || (location.y < 0) || (location.x > currentView.bounds.size.width) || (location.y > currentView.bounds.size.height))) {
            
            [self performSegueWithIdentifier:@"specificColor" sender:currentView];
        }
    }

 //   NSLog(@"tapped dat ass at: %f, %f", location.x, location.y);
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"specificColor"]) {
        UIView *send = sender;
        ADKColorViewController *destination = segue.destinationViewController;
        destination.color = send.backgroundColor;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.pictureToBeAnalyzed.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    CGRect indicatorBounds = CGRectMake(self.pictureToBeAnalyzed.bounds.size.width / 2 - 12,
                                        self.pictureToBeAnalyzed.bounds.size.height / 2 - 12, 24, 24);
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithFrame:indicatorBounds];
    indicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.tag  = 1;
    [indicator startAnimating];
    [self.pictureToBeAnalyzed addSubview:indicator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewAfterKmean)
                                                 name:@"Done with K Mean"
                                               object:nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        // Some asynchronous work
        [self kMean:self.pictureToBeAnalyzed.image];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"Done with K Mean"
         object:self];
    });

    
    
    
    
}

-(void)updateViewAfterKmean{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray* prominentColor = [self.photoDataModel getTopThreeColors];
        self.imageColorOne.backgroundColor = prominentColor[0];
        self.imageColorTwo.backgroundColor = prominentColor[1];
        self.imageColorThree.backgroundColor = prominentColor[2];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.pictureToBeAnalyzed viewWithTag:1];
        [indicator removeFromSuperview];
        
        if ([self.colorRelationLabel.text isEqualToString:@"Split Complement Colors:"]) {
            [self splitComplement];
        }
        if ([self.colorRelationLabel.text isEqualToString:@"Triadic Harmony:"]) {
            [self triadic];
        }
        if ([self.colorRelationLabel.text isEqualToString:@"Analogous Colors:"]) {
            [self analogous];
        }
        if ([self.colorRelationLabel.text isEqualToString:@"Monochromatic Colors:"]) {
            [self monochromatic];
        }
        if ([self.colorRelationLabel.text isEqualToString:@"Complementing Colors:"]) {
            [self complement];
        }
        self.backgroundView.alpha = 0.1;
        
    });

}

- (void)splitComplement{
    self.colorRelationLabel.text = @"Split Complement Colors:";
    CGFloat hFloat,sFloat,bFloat,aFloat;
    
    [self.imageColorOne.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorOne.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorTwo.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorTwo.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorThree.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorFour.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorThree.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorFive.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorSix.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (100.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];

}

- (void)triadic{
    self.colorRelationLabel.text = @"Triadic Harmony:";
    CGFloat hFloat,sFloat,bFloat,aFloat;
    
    
    [self.imageColorOne.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorOne.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorTwo.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorTwo.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorThree.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorFour.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorThree.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorFive.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorSix.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (120.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
  }

- (void)analogous{
    self.colorRelationLabel.text = @"Analogous Colors:";
    CGFloat hFloat,sFloat,bFloat,aFloat;
    
    [self.imageColorOne.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorOne.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorTwo.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorTwo.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorThree.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorFour.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    
    [self.imageColorThree.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorFive.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorSix.backgroundColor = [[UIColor alloc] initWithHue:(hFloat - (30.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
}

- (void)monochromatic{
    self.colorRelationLabel.text = @"Monochromatic Colors:";
    CGFloat hFloat,sFloat,bFloat,aFloat;

    [self.imageColorOne.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorOne.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 1.5) alpha:aFloat];
    self.complementaryColorTwo.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 0.5) alpha:aFloat];
    
    [self.imageColorTwo.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorThree.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 1.5) alpha:aFloat];
    self.complementaryColorFour.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 0.5) alpha:aFloat];
    
    [self.imageColorThree.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorFive.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 1.5) alpha:aFloat];
    self.complementaryColorSix.backgroundColor = [[UIColor alloc] initWithHue:(hFloat) saturation:sFloat brightness:(bFloat * 0.5) alpha:aFloat];
}

- (void)complement{
    self.colorRelationLabel.text = @"Complementing Colors:";
    CGFloat hFloat,sFloat,bFloat,aFloat;
    
    [self.imageColorOne.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorOne.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (180.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorTwo.hidden = YES;
    
    [self.imageColorTwo.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorThree.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (180.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorFour.hidden = YES;
    
    [self.imageColorThree.backgroundColor getHue:&hFloat saturation:&sFloat brightness:&bFloat alpha:&aFloat];
    self.complementaryColorFive.backgroundColor = [[UIColor alloc] initWithHue:(hFloat + (180.0/360.0)) saturation:sFloat brightness:bFloat alpha:aFloat];
    self.complementaryColorSix.hidden = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (actionSheet.tag) {
        case 1: //camera
            switch (buttonIndex) {
                case 0:
                    [self takePicture];
                    break;
                case 1:
                    [self selectPicture];
                    break;
                default:
                    break;
            }
            break;
        case 2://color relation
            switch (buttonIndex) {
                case 0:
                    [self triadic];
                    break;
                case 1:
                    [self splitComplement];
                    break;
                case 2:
                    [self analogous];
                    break;
                case 3:
                    [self monochromatic];
                    break;
                case 4:
                    [self complement];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    
    }


- (void)takePicture{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)selectPicture{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


- (void)kMean:(UIImage*)image{
//    UIImage *originalImage = image;
//    CGSize destinationSize = CGSizeMake(200, 200); //<----this break everything? why?
//    UIGraphicsBeginImageContext(destinationSize);
//    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
//    UIImage *shrunkenImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    CGImageRef cgImage = [image CGImage];
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    const UInt8* data = CFDataGetBytePtr(bitmapData);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    // NSMutableArray* centers = self.photoDataModel.centers; //<--------- Ask bri about this
    
    //init and array of ColorClusters
    for (int i = 0; i < K; i++) {
        self.photoDataModel.centers[i] = [[ADKColorCluster alloc] init];
        [self.photoDataModel.centers[i] setClusterCenter:[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]];
        [self.photoDataModel.centers[i] setColorPoints:[[NSMutableArray alloc] init]];
    }
   // NSLog(@"width: %d, height: %d", width, height);
    //set up dif
    float dif = 10000000.0;
    float smallestDif = 10000000.0;
    ADKColorCluster* tempCluster = [[ADKColorCluster alloc] init];
    int index = 0;
    UIColor* pixelColor;
    while (dif > MIN_MOVE_DISTANCE) {
        for (int i = 0; i < width; i+=10) {
            for (int j = 0; j< height; j+=10) {
                const UInt8* pixel = data + j*bytesPerRow+i*4;
                
                pixelColor = [[UIColor alloc] initWithRed:(pixel[0]/255.0) green:(pixel[1]/255.0) blue:(pixel[2]/255.0) alpha:1.0];
                smallestDif = 10000.0;
                for (int c = 0; c < K; c++) {
                    tempCluster = self.photoDataModel.centers[c];
                    float distance = [self.photoDataModel calculateEuclideanDistanceBetweenColorA:pixelColor andColorB: (tempCluster.clusterCenter)];
                    
                    if (distance < smallestDif) {
                        smallestDif = distance;
                        index = c;
                    }
                }
                //add UIColor at x,y to proper cluster
                
                [[self.photoDataModel.centers[index] colorPoints] addObject:pixelColor];
                dif = [self.photoDataModel.centers[index] updateClusterCenter];
                //                self.photoDataModel.centers[index] = tempCluster;
            }
        }
    }
}
- (IBAction)colorRelation:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Triadic Harmony", @"Split Complement", @"Analogous", @"Monochromatic",@"Complement", nil];
    actionSheet.tag = 2;
    [actionSheet showInView:self.view];
    
    self.complementaryColorTwo.hidden = NO;
    self.complementaryColorFour.hidden = NO;
    self.complementaryColorSix.hidden = NO;
}
@end
