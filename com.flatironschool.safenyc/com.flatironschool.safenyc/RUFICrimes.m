//
//  RUFICrimes.m
//  testApp
//
//  Created by Rosario Tarabocchia on 3/29/16.
//  Copyright © 2016 RLDT. All rights reserved.
//

#import "RUFICrimes.h"


//@property (nonatomic, strong) NSString *offense;
//@property (nonatomic, strong) NSString *precinct;
//@property (nonatomic, strong) NSString *date;
//@property (nonatomic, strong) NSString *day;
//@property (nonatomic, strong) NSString *month;
//@property (nonatomic, strong) NSString *year;
//@property (nonatomic, assign) float latitude;
//@property (nonatomic, assign) float longitude;

@implementation RUFICrimes

+(RUFICrimes *)crimeFromDictionary:(NSDictionary *)crimeDictionary {
    
    RUFICrimes *crime = [[RUFICrimes alloc] init];
    crime.offense = crimeDictionary[@"offense"];
    crime.precinct = [NSString stringWithFormat:@"Precinct %@", crimeDictionary[@"precinct"]];
    crime.day = crimeDictionary[@"occurrence_day"];
    crime.month = crimeDictionary[@"occurrence_month"];
    crime.year = crimeDictionary[@"occurrence_year"];
    crime.date = [NSString stringWithFormat:@"%@-%@-%@", crime.month, crime.day, crime.year];
    crime.latitude = [crimeDictionary[@"location_1"][@"latitude"] doubleValue];
    crime.longitude = [crimeDictionary[@"location_1"][@"longitude"] doubleValue];
    crime.googleMapsIcon = [UIImage imageNamed:crimeDictionary[@"offense"]];
    
    return crime;
}



@end
