//
//  PoliceLocation.h
//  com.flatironschool.safenyc
//
//  Created by Felix Changoo on 4/4/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoliceLocation : NSObject

@property(nonatomic, strong)NSString *locationName;
@property(nonatomic, strong)NSString *locationAddress;
@property(nonatomic, assign)double latitude;
@property(nonatomic, assign)double longitude;

+(PoliceLocation *)createPoliceLocationWithDictionary:(NSDictionary *)locationInfo;

@end
