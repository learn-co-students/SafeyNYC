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
#import <INTULocationManager.h>
#import "PoliceLocatorAPI.h"
#import "PoliceDataStore.h"
#import "RUFIEmergencyViewController.h"

@import GoogleMaps;
@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) NSString *currentAddress;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) RUFIDataStore *datastore;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) GMSPolyline *policePolyline;
@property (strong, nonatomic) GMSMarker *policeMarker;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, assign) BOOL searchLocation;
@property (nonatomic, assign) BOOL policeLocationFoundForActualCurrentLocation;

-(void)reloadViewAfterSettingsScreen:(NSNotification *)notification;



@end

