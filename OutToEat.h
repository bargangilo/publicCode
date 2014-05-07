//
//  OutToEat.h
//  Out To Eat
//
//  Created by Donovan King on 4/30/14.
//  Copyright (c) 2014 Donovan King. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OutToEat : NSManagedObject

@property (nonatomic, retain) NSNumber * numberOfTime;
@property (nonatomic, retain) NSDate * sinceDate;
@property (nonatomic, retain) NSNumber * totalMoneySpent;

@end
