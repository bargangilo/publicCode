//
//  ADKPhotoDataModel.h
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADKPhotoDataModel : NSObject
@property (strong) NSMutableArray* centers;

-(float)calculateEuclideanDistanceBetweenColorA:(UIColor *)colorA andColorB:(UIColor *)colorB;

- (NSMutableArray*)getTopThreeColors;
@end
