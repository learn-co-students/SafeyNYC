//
//  PoliceLocatorAPI.m
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "PoliceLocatorAPI.h"

@implementation PoliceLocatorAPI

+(void)getPoliceLocationsLatitude:(double )latitude
                        Longitude:(double )longitude
                   WithCompletion:(void (^)(NSArray *policeLocations))completionBlock{

//    test values
//    NSString *radius = @"10000";
    
    //https://maps.googleapis.com/maps/api/place/nearbysearch/json?&name=new+york+city+police+department&location=40.705597,-74.013991&rankby=distance&key=AIzaSyA3sVpYkTVZgOPiV-A0OkDQODMcnVvCYpg
    
//    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?type=police&location=%f,%f&radius=%@&key=%@", latitude, longitude, radius,GOOGLE_PLACES_API_KEY];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?name=%@&location=%f,%f&rankby=distance&key=%@",@"new+york+city+police+department",latitude, longitude, GOOGLE_PLACES_API_KEY];
    
//    NSLog(@"here's the get request: %@", urlString); 
    
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    
    [sessionManger GET: urlString parameters: nil progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //write badass code here
//        NSLog(@"lat: %f", latitude);
//        NSLog(@"long: %f", longitude);
        NSArray *results = responseObject[@"results"];
        NSLog(@"and here are the results =======> : %@", results);
        
        completionBlock(results);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"here is the error object: %@", error);
        
    }];


}
@end

