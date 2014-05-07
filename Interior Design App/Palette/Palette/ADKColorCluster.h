//
//  ADKColorCluster.h
//  Palette
//
//  Created by Donovan King on 4/11/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADKColorCluster : NSObject
@property (strong) UIColor* clusterCenter;
@property (strong) NSMutableArray* colorPoints;

//Returns distance from old center of cluster to the new center of cluster
- (float)updateClusterCenter;

- (NSInteger)getNumberOfColorPoints;

@end