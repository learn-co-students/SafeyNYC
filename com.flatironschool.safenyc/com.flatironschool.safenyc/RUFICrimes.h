//
//  RUFICrimes.h
//  testApp
//
//  Created by Rosario Tarabocchia on 3/29/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RUFICrimes : NSObject

@property (nonatomic, strong) NSString *offense;
@property (nonatomic, strong) NSString *precinct;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

+(RUFICrimes *)crimeFromDictionary:(NSDictionary *)crimeDictionary;


@end
