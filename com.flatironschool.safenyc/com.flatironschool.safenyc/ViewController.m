//
//  ViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 3/29/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "ViewController.h"
@import GoogleMaps;

@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.longitude = -74.014002;
    self.latitude = 40.805443;
    
    [self promptForLocationServices];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                            longitude: self.longitude
                                                                 zoom: 17];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    GMSMarker *marker = [[GMSMarker alloc] init];
    //marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    marker.title = @"New York";
    marker.snippet = @"USA";

    marker.map = mapView_;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self findTheCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)findTheCurrentLocation{
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    NSLog(@"we are about to find the location!!!!!");
    [self.locationManager startUpdatingLocation];

}

-(void)promptForLocationServices{
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        
        self.locationManager = [[CLLocationManager alloc]init];
        [self findTheCurrentLocation];
        
    }
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"There was an error retrieving your location"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    
    [self animateMap];

    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"lat is now: %f", self.latitude);
    NSLog(@"long is now: %f", self.longitude);

    

}

-(void)animateMap{
    
    [mapView_ animateToLocation:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    
}

#pragma method to update map with crime markers

-(void)updateMapWithCrimeLocations:(NSMutableArray *)crimeArray {
    
    for (RUFICrimes *crime in crimeArray){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
        marker.position = CLLocationCoordinate2DMake(crime.latitude, crime.longitude);
        marker.icon = crime.googleMapsIcon;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = crime.offense;
        marker.snippet = crime.date;
        marker.map = mapView_;
        
        }
}

@end
