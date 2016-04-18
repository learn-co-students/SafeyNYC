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
        

        if ([self policeLocationsArrayContainsError: policeLocations]) {
            
            completionBlock(NO);
        }
        else{
        
            for (NSDictionary *currentPoliceDictionary in policeLocations) {
                
//                if ([currentPoliceDictionary[@"name"] containsString: @"Police"]) {
                
                    PoliceLocation *newLocation = [PoliceLocation createPoliceLocationWithDictionary: currentPoliceDictionary];
                    [self.policeLocationsArray addObject: newLocation];
//                }
            }
            
            [self filterPoliceLocations];
            NSLog(@"Police Locations array contains: %lu locations!!!!!!", self.policeLocationsArray.count);
            
            if ([self getCurrentPoliceLocationsCount] > 0) {
                
                completionBlock(YES);
            }
            else{
                
                completionBlock(NO);
            }
            
        
        }

    }];


}

-(void)clearPoliceLocationsArray{
    
    [self.policeLocationsArray removeAllObjects];

}

-(NSUInteger)getCurrentPoliceLocationsCount{

    NSInteger policeLocationCount = self.policeLocationsArray.count;

    return policeLocationCount;

}

-(BOOL)policeLocationsArrayContainsError:(NSArray *)policeLocationsArray{

    BOOL hasErrorMessage = [policeLocationsArray.firstObject isKindOfClass:[NSString class]];
    
    return hasErrorMessage;

}

-(void)filterPoliceLocations{

    NSArray *filterStrings = @[@"New York City Police Department", @"Police Department"];
    NSString *filter = @"%K CONTAINS[cd] %@";
    NSPredicate *filterUsingThisPredicate = [[NSPredicate alloc]init];
    NSUInteger countOfLocationsInNY;
    
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:filter, @"locationName", filterStrings[0]];
        
    countOfLocationsInNY = [self.policeLocationsArray filteredArrayUsingPredicate: testPredicate].count;

        
        if (countOfLocationsInNY > 0) {
            
            filterUsingThisPredicate = testPredicate;
            
        }
        else {
        
            filterUsingThisPredicate = [NSPredicate predicateWithFormat:filter, @"locationName", filterStrings[1]];
        
        }
    
   self.policeLocationsArray = [[self.policeLocationsArray filteredArrayUsingPredicate: filterUsingThisPredicate]mutableCopy];
    
}

@end
