//
//  ViewController.h
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 3/29/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RUFIDataStore.h"

@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *currentAddress;

@end

