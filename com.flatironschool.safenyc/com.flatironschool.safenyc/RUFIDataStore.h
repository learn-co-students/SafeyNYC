//
//  RUFIDataStore.h
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/30/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUFICrimes.h"

@interface RUFIDataStore : NSObject

@property (strong, nonatomic) NSMutableArray *crimeDataArray;
@property (strong, nonatomic) NSString *userLatitude;
@property (strong, nonatomic) NSString *userLongitude;
@property (strong, nonatomic) NSString *distanceInMiles;
@property (strong, nonatomic) NSString *distanceInMeters;
@property (strong, nonatomic) NSString *distanceValue;
@property (strong, nonatomic) NSString *yearsAgo;
@property (assign, nonatomic) NSUInteger grandLarcenyCount;
@property (assign, nonatomic) NSUInteger felonyAssaultCount;
@property (assign, nonatomic) NSUInteger murderCount;
@property (assign, nonatomic) NSUInteger rapeCount;
@property (assign, nonatomic) NSUInteger robberyCount;
@property (assign, nonatomic) NSUInteger grandLarcenyMVCount;
@property (assign, nonatomic) NSUInteger burglaryCount;
+ (instancetype)sharedDataStore;

-(void)getCrimeDataWithCompletion:(void (^)(BOOL finished))completionBlock;

@end
