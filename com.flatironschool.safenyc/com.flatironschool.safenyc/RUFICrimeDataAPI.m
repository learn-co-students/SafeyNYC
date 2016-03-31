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

+(void)getCrimeDataWithCompletion:(void (^)(NSArray *))completionBlock {
    
    RUFIDataStore *sharedData = [[RUFIDataStore alloc]init];
    
    NSDate *now = [NSDate date];
    NSDateComponents *minusOneYear = [NSDateComponents new];
    minusOneYear.year = -1;
    NSDate *oneYearAgo = [[NSCalendar currentCalendar] dateByAddingComponents:minusOneYear
                                                                            toDate:now
                                                                           options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateOneYearAgo = [formatter stringFromDate:oneYearAgo];
    
//    NSString *cityDataUrl = [NSString stringWithFormat:@"https://data.cityofnewyork.us/resource/dvh8-u7es.json?%@&$where=occurrence_date>='%@T00:00:00' AND within_circle(location_1, %@, %@, 201)&$order=occurrence_date", CITY_CRIME_APP_TOKEN, sharedData.userLatitude, sharedData.userLongitude, dateOneYearAgo];
    
    NSString *cityDataUrl = @"https://data.cityofnewyork.us/resource/dvh8-u7es.json?$$app_token=7wq8JZEbZGGNxPWQ0LFQQbNir&$where=occurrence_date>='2013-03-29T00:00:00' AND within_circle(location_1, 40.705443, -74.014002, 201)&$order=occurrence_date";
    NSString *cityDataUrLEncoded = [cityDataUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
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
