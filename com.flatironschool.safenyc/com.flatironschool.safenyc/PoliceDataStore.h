//
//  PoliceDataStore.h
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoliceLocatorAPI.h"
#import "PoliceLocation.h"

@interface PoliceDataStore : NSObject

@property (nonatomic, strong)NSMutableArray *policeLocationsArray;

+(instancetype)sharedDataStore;
-(void)getPoliceLocationsLatitude:(double)latitude
                        Longitude:(double)longitude
                   WithCompletion:(void (^)(BOOL finished))completionBlock;


@end
