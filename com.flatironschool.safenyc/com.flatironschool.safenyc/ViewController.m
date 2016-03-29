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
    self.latitude = 40.705443;
    
//    [self promptForLocationServices];
    NSLog(@"About to update the map in the view controller!!!!!!");
    NSLog(@"%f", self.longitude);
    NSLog(@"%f", self.latitude);
    [self updateMapWithCoordinates];
    
}

//-(void)viewDidAppear:(BOOL)animated{
//
//    [super viewDidAppear: YES];
//    
//    [self promptForLocationServices];
//
//   [self updateMapWithCoordinates];
//
//}

-(void)updateMapWithCoordinates{

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                            longitude: self.longitude
                                                                 zoom: 17];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    marker.title = @"New York";
    marker.snippet = @"USA";
    marker.map = mapView_;


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
        NSLog(@"looks like this shit works!");
    }
    
    [self.locationManager startUpdatingLocation];
    
    
}


//- (IBAction)getCurrentLocation:(id)sender {
//    
//    [self findTheCurrentLocation];
//}

-(void)promptForLocationServices{
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (!locationAllowed) {
        
        NSLog(@"LOCAtion not ALLOWED!!!!!");
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enable Location Services"
                                                                       message:@"To enable, please go to Settings and turn on Location Services for this app."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  
                                                                  
                                                              }];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else{
        
        NSLog(@"WE WILL NOW MAKE THE MANAGER");
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.geocoder = [[CLGeocoder alloc]init];
        
        [self findTheCurrentLocation];
        
    }
    
    
    
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"Here's the error: %@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Failed to get the damn coordinates mein.."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    
    self.latitude = location.coordinate.latitude;
    NSLog(@"the latitude is : %.6f", self.latitude);
    self.longitude = location.coordinate.longitude;
    NSLog(@"the longitude is : %.6f", self.longitude);
//
//            [self.geocoder reverseGeocodeLocation: location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//    
//                NSLog(@"The placemarks were found!!!!!!!");
//    
//                if ((error == nil && placemarks.count > 0)) {
//                    self.placemark = placemarks.lastObject;
//    
//                    self.currentAddress= [NSString stringWithFormat:@"Address: %@ %@\n%@ %@\n%@\n%@",
//                                              self.placemark.subThoroughfare, self.placemark.thoroughfare,
//                                              self.placemark.postalCode, self.placemark.locality,
//                                              self.placemark.administrativeArea,
//                                              self.placemark.country];
//    
//                } else {
//                    NSLog(@"%@", error.debugDescription);
//                }
//            }];

    
    [self.locationManager stopUpdatingLocation];
    
    
}

@end
