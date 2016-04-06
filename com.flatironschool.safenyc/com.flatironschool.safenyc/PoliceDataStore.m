//
//  PoliceDataStore.m
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "PoliceDataStore.h"

@implementation PoliceDataStore

+(instancetype)sharedDataStore {
    static PoliceDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[PoliceDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        _policeLocationsArray = [[NSMutableArray alloc]init];
    }

    return self;
}

//lat = "40.75705860000001";
//lng = "-73.9904105";
//Test data for lat and long

-(void)getPoliceLocationsLatitude:(double)latitude
                        Longitude:(double)longitude
                   WithCompletion:(void (^)(BOOL finished))completionBlock{
    
    [self clearPoliceLocationsArray]; 

    [PoliceLocatorAPI getPoliceLocationsLatitude: latitude  Longitude: longitude WithCompletion:^(NSArray *policeLocations) {
        

            for (NSDictionary *currentPoliceDictionary in policeLocations) {
            
//            if ([currentPoliceDictionary[@"name"] containsString: @"Precinct"]) {
            
                PoliceLocation *newLocation = [PoliceLocation createPoliceLocationWithDictionary: currentPoliceDictionary];
                [self.policeLocationsArray addObject: newLocation];
//            }
        }
        
        NSLog(@"Police Locations array contains: %lu locations!!!!!!", self.policeLocationsArray.count);
        completionBlock(YES);
    }];
    

}

-(void)clearPoliceLocationsArray{
    
    [self.policeLocationsArray removeAllObjects];

}




@end
