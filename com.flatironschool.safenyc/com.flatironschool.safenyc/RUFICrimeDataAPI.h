//
//  RUFICrimeDataAPI.h
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/30/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RUFIDataStore.h"

@interface RUFICrimeDataAPI : NSObject

@property (nonatomic, strong) RUFIDataStore *sharedData;

+(void)getCrimeDataFromLatitude: (NSString *) latitude longitude: (NSString *) longitude timePeriod: (NSInteger)years distance:(NSString *)radius withCompletion: (void (^)(NSArray *))completionBlock;

@end
