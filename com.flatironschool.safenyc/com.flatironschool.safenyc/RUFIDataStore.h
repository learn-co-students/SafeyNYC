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

+ (instancetype)sharedDataStore;

@end
