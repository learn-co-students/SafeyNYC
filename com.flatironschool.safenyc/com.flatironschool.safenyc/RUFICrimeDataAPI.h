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

+(void)getCrimeDataWithCompletion:(void (^)(NSArray *crimeDictionaries))completionBlock;

@end
