//
//  ADKViewController.m
//  Out To Eat
//
//  Created by Donovan King on 4/30/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import "ADKViewController.h"
#import "OutToEat.h"


@interface ADKViewController ()

@end

@implementation ADKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    NSString *documentName = @"outToEatData";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [self.document openWithCompletionHandler:^(BOOL success){
          
            if (success) {
                [self loadPrevData];
            }
            if (!success) {
                NSLog(@"not success");
            }
        }];
    } else {
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            
            if (success) {
                [self setUpNewData];
            }
            if (!success) {
                NSLog(@"not save success");
            }
        }];
    }
    
}

- (void)setUpNewData{
    
    if (self.document.documentState == UIDocumentStateNormal) {
        NSManagedObjectContext *context = self.document.managedObjectContext;
        self.loadedData = [NSEntityDescription insertNewObjectForEntityForName:@"OutToEat" inManagedObjectContext:context];
 //       [self loadedData];
//        [self.timesThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.numberOfTime]];
//        [self.cashThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.totalMoneySpent]];
        //UIManaged Docs are AutoSaved
    }
}

- (void)loadPrevData{
    
    if (self.document.documentState == UIDocumentStateNormal) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OutToEat"];
        NSManagedObjectContext *context = self.document.managedObjectContext;
        NSArray *tempArray = [context executeFetchRequest:request error:nil];
        self.loadedData = tempArray[0];
        [self.timesThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.numberOfTime]];
        [self.cashThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.totalMoneySpent]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wentOutClicked:(UIButton *)sender {
    
    NSString *amountFromTextField = [[NSString alloc] init];
    amountFromTextField = self.costInput.text;
    
//    int costOfFood;
    NSInteger times = [self.loadedData.numberOfTime intValue];
    float cash = [self.loadedData.totalMoneySpent floatValue];
    cash = cash + [amountFromTextField floatValue];
    times++;
    
    self.loadedData.numberOfTime = [[NSNumber alloc] initWithInteger:times];
    self.loadedData.totalMoneySpent = [[NSNumber alloc] initWithFloat:cash];

    [self.timesThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.numberOfTime]];
    [self.cashThisMonth setText:[NSString stringWithFormat:@"%@", self.loadedData.totalMoneySpent]];
    
    [self.costInput endEditing: YES];
    
    
}
@end
