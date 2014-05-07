//
//  ADKPhotoDataModel.m
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import "ADKPhotoDataModel.h"
#import "ADKColorCluster.h"
#define K 8

@implementation ADKPhotoDataModel

- (instancetype)init{
    self = [super init];  // double check init override
    if (self) {
        self.centers = [[NSMutableArray alloc] initWithCapacity:K];
    }
    return self;
}

- (float)calculateEuclideanDistanceBetweenColorA:(UIColor *)colorA andColorB:(UIColor *)colorB{
    
    //init vars
    float distance = 0.0;
    CGFloat redA = 0.0;
    CGFloat greenA = 0.0;
    CGFloat blueA = 0.0;
    CGFloat redB = 0.0;
    CGFloat greenB = 0.0;
    CGFloat blueB = 0.0;
    
    
    //put RGB values into holder vars
    [colorA getRed:&redA green:&greenA blue:&blueA alpha:nil];
    [colorB getRed:&redB green:&greenB blue:&blueB alpha:nil];

    //perform Euclidean distance calc
    distance = sqrt((pow((redA - redB), 2) + pow((greenA - greenB), 2) + pow((blueA - blueB), 2)));
    
    return distance;
}

- (NSMutableArray *)getTopThreeColors{
    NSMutableArray* topThree = [[NSMutableArray alloc] initWithCapacity:3];
    ADKColorCluster* currentCluster = [[ADKColorCluster alloc] init];
    NSInteger numberOfDataPointsInCluster = 0;
    NSInteger one = 0;
    NSInteger two = 0;
    NSInteger three = 0;
    
    for (int i = 0; i<3; i++) {
        [topThree addObject:[[UIColor alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]]; 
    }
    
    for (int i = 0; i < K; i++) {
        numberOfDataPointsInCluster = [self.centers[i] getNumberOfColorPoints];
        currentCluster = self.centers[i];
        if (numberOfDataPointsInCluster > one) {
            three = two;
            topThree[2] = topThree[1];
            two = one;
            topThree[1] = topThree[0];
            one = numberOfDataPointsInCluster;
            topThree[0] = currentCluster.clusterCenter;
        }
        if ((numberOfDataPointsInCluster < one) && (numberOfDataPointsInCluster > two)) {
            three = two;
            topThree[2] = topThree[1];
            two = numberOfDataPointsInCluster;
            topThree[1] = currentCluster.clusterCenter;
        }
        if ((numberOfDataPointsInCluster < two) && (numberOfDataPointsInCluster > three)) {
            three = two;
            topThree[2] = topThree[1];
            three = numberOfDataPointsInCluster;
            topThree[2] = currentCluster.clusterCenter;
        }
    }
    return topThree;
}
@end
