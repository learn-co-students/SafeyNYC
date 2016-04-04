//
//  PoliceLocation.m
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "PoliceLocation.h"

@implementation PoliceLocation

+(PoliceLocation *)createPoliceLocationWithDictionary:(NSDictionary *)locationInfo{

    PoliceLocation *currentLocation = [[PoliceLocation alloc] init];
    
    currentLocation.locationName = locationInfo[@"name"];
    currentLocation.latitude = [locationInfo[@"location"][@"lat"] doubleValue];
    currentLocation.longitude = [locationInfo[@"location"][@"lng"] doubleValue];
    currentLocation.locationAddress = locationInfo[@"vicinity"];
    
    return currentLocation;
}

@end
