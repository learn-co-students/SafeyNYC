//
//  PoliceLocatorAPI.h
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RUFIConstants.h"

@interface PoliceLocatorAPI : NSObject

+(void)getPoliceLocationsLatitude:(double )latitude
                         Longitude:(double )longitude
           WithCompletion:(void (^)(NSArray *policeLocations))completionBlock;

@end
