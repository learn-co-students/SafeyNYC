//
//  RUFICrimeDataAPI.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/30/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFICrimeDataAPI.h"
#import "RUFIConstants.h"

#import <AFNetworking/AFNetworking.h>

@implementation RUFICrimeDataAPI

+(void)getCrimeDataFromLatitude: (NSString *) latitude longitude: (NSString *) longitude withCompletion: (void (^)(NSArray *))completionBlock {
    
    
    NSLog(@"GETTING TO HERE");
    
    NSLog(@"LADITUDE IN API %@", latitude);
    NSLog(@"LONGITUDE IN API %@", longitude);

    
    NSDate *now = [NSDate date];
    NSDateComponents *minusYears = [NSDateComponents new];
    minusYears.year = -2;
    NSDate *oneYearAgo = [[NSCalendar currentCalendar] dateByAddingComponents:minusYears
                                                                            toDate:now
                                                                           options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateOneYearAgo = [formatter stringFromDate:oneYearAgo];
    
    NSString *cityDataUrl = [NSString stringWithFormat:@"https://data.cityofnewyork.us/resource/dvh8-u7es.json?%@&$where=occurrence_date>='%@T00:00:00' AND within_circle(location_1, %@, %@, 401)&$order=occurrence_date&$limit=2000", CITY_CRIME_APP_TOKEN, dateOneYearAgo, latitude, longitude];
    
    NSString *cityDataUrLEncoded = [cityDataUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

//    40.705443, -74.014002
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:cityDataUrLEncoded
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             completionBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Fail: %@",error.localizedDescription);
         }];

}

@end
