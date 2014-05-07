//
//  ADKColorCluster.m
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import "ADKColorCluster.h"
#import "ADKPhotoDataModel.h"

@implementation ADKColorCluster

- (float)updateClusterCenter{
    
    UIColor* oldClusterCenter = self.clusterCenter; //check here for bug <-------(Deep Copy?)
    
    //    UIColor* colorDataPoint = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    ADKPhotoDataModel* distanceCalculator = [[ADKPhotoDataModel alloc] init];
    
    CGFloat centerRed = 0.0;
    CGFloat centerGreen = 0.0;
    CGFloat centerBlue = 0.0;
    CGFloat pointRed = 0.0;
    CGFloat pointGreen = 0.0;
    CGFloat pointBlue = 0.0;
    
    
    for (int i = 0; i < [self.colorPoints count]; i++) {
        
        [self.colorPoints[i] getRed:&pointRed green:&pointGreen blue:&pointBlue alpha:nil];
        //red
        centerRed = centerRed + pointRed;
        //green
        centerGreen = centerGreen + pointGreen;
        //blue
        centerBlue = centerBlue + pointBlue;
        
    }
    centerRed = centerRed/[self.colorPoints count];
    centerGreen = centerGreen/[self.colorPoints count];
    centerBlue = centerBlue/[self.colorPoints count];
    
    self.clusterCenter = [[UIColor alloc] initWithRed:centerRed green:centerGreen blue:centerBlue alpha:1.0];
    // NSLog(@"Cluster center: %f, %f, %f", centerRed, centerGreen, centerBlue);
    return [distanceCalculator calculateEuclideanDistanceBetweenColorA:oldClusterCenter andColorB:self.clusterCenter];
}

- (NSInteger)getNumberOfColorPoints{
    return [self.colorPoints count];
}
@end
