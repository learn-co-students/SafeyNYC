//
//  ViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 3/29/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(reloadViewAfterSettingsScreen:)
                                                 name:@"Reload Map"
                                               object:nil];
    
    [self updateCurrentLocationCoordinatesWithBlock:^(BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                [self createMapWithCoordinates];
            }
        }];
        
       
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear: YES];
    [self updateCurrentMap];

}

- (void)openSettings
{
    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)updateCurrentMap{

    [self updateCurrentLocationCoordinatesWithBlock:^(BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                
                if(self.mapView_ == nil){
                    [self createMapWithCoordinates];
                }
                else{
                    [self animateMap];
                }

            }
        }];
        
        
    }];

}

-(void)reloadViewAfterSettingsScreen:(NSNotification *)notification{

    if ([notification.name isEqualToString: @"Reload Map"]) {
        [self updateCurrentMap];
    }

}

- (NSString *)getLocationErrorDescription:(INTULocationStatus)status
{
    
    if (status == INTULocationStatusServicesNotDetermined) {
        return @"User has not responded to the permissions alert.";
    }
    if (status == INTULocationStatusServicesDenied) {
        return @"User has denied this app permissions to access device location.\nGo to settings > Privacy > Location Services and switch on";
    }
    if (status == INTULocationStatusServicesRestricted) {
        return @"User is restricted from using location services by a usage policy. \nGo to settings > Privacy > Location Services and switch on";
    }
    if (status == INTULocationStatusServicesDisabled) {
        return @"Location services are turned off for all apps on this device.\nGo to settings > Privacy > Location Services and switch on";
    }
    return @"An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)";
}

- (void)updateCurrentLocationCoordinatesWithBlock:(void (^) (BOOL success))block {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    [locMgr requestLocationWithDesiredAccuracy: INTULocationAccuracyRoom timeout: 1.5 delayUntilAuthorized: YES block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            
            self.longitude = currentLocation.coordinate.longitude;
            self.latitude = currentLocation.coordinate.latitude;
            block(YES);
        }
        
        else if(status == INTULocationStatusTimedOut){
            
            self.longitude = currentLocation.coordinate.longitude;
            self.latitude = currentLocation.coordinate.latitude;
            block(YES);

        }
        else{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message: [self getLocationErrorDescription: status]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [self updateCurrentLocationCoordinatesWithBlock:^(BOOL success) {
                                                                          if(success){
                                                                          
                                                                              if(self.mapView_ == nil){
                                                                                  [self createMapWithCoordinates];
                                                                              }
                                                                              else{
                                                                                  [self animateMap];
                                                                              }
                                                                          }
                                                                      }];
                                                                  }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Exit" style: UIAlertActionStyleDestructive
                                                                 handler:^(UIAlertAction * action) {
                                                                     exit(0);
                                                                 }];
            
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            
            if (status == INTULocationStatusServicesDisabled || status == INTULocationStatusServicesRestricted) {
                UIAlertAction* settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         [self openSettings];
                                                                     }];
                [alert addAction: settingsAction];

            }
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        block(NO);

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createMapWithCoordinates{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                            longitude: self.longitude
                                                                 zoom: 17];
    
    self.mapView_ = [GMSMapView mapWithFrame: self.view.bounds camera:camera];
    self.mapView_.myLocationEnabled = YES;
    self.view = self.mapView_;

}


-(void)animateMap{

    [self.mapView_ animateToLocation:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    
}

@end
