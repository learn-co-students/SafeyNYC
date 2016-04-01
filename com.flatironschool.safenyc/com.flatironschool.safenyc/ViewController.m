//
//  ViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 3/29/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <DKCircleButton/DKCircleButton.h>

@import GoogleMaps;

@interface ViewController () <GMSAutocompleteViewControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) DKCircleButton *searchButton;
@property (strong, nonatomic) DKCircleButton *settingsButton;
@property (strong, nonatomic) DKCircleButton *currentLocationButton;
@property (strong, nonatomic) DKCircleButton *policeMapButton;
@property (strong, nonatomic) DKCircleButton *emergencyButton;
@property (strong, nonatomic) DKCircleButton *pieChartButton;


@end


@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(reloadViewAfterSettingsScreen:)
                                                 name:@"Reload Map"
                                               object:nil];
    [self createMapWithCoordinates];
    [self updateCurrentMap];
    
//    [self setSearchBar];

    [self setUpButtons];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self updateCurrentMap];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpButtons{
    
    self.searchButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 20, 47, 47)];
    self.settingsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 80, 47, 47)];
    self.currentLocationButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 140, 47, 47)];
    self.policeMapButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 200, 47, 47)];
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 260, 47, 47)];
    self.pieChartButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 320, 47, 47)];
    
    NSArray *buttons = @[self.searchButton, self.settingsButton, self.currentLocationButton, self.policeMapButton, self.emergencyButton, self.pieChartButton];
    
    for (DKCircleButton *button in buttons) {

        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        button.backgroundColor = [UIColor whiteColor];
        button.borderColor = [UIColor grayColor];
        button.alpha = 0.6;
        
        UIImage *image = [UIImage new];
        if(button == self.searchButton){
            image = [UIImage imageNamed:@"search.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        } else if (button == self.settingsButton){
            image = [UIImage imageNamed:@"settings.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            
        } else if (button == self.currentLocationButton){
            image = [UIImage imageNamed:@"currentLocation.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            
        } else if (button == self.policeMapButton){
            image = [UIImage imageNamed:@"policeMap.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            
        } else if (button == self.emergencyButton){
            image = [UIImage imageNamed:@"emergency.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            
        } else if (button == self.pieChartButton){
            image = [UIImage imageNamed:@"pieChart.png"];
            button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
            
        }
        [button setImage:image forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeTop];

        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)pressedSearchButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.searchButton){
        [self openGooglePlacePicker];
    }
}

-(void)findTheCurrentLocation{
    
    [self updateCurrentLocationCoordinatesWithBlock:^(BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                [self createMapWithCoordinates];
            }
        }];
        
       
    }];
    
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
                
                if(self.mapView == nil){
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
        return @"Error: User has not responded to the permissions alert.";
    }
    if (status == INTULocationStatusServicesDenied) {
        return @"Error: User has denied this app permissions to access device location.\nGo to settings > Privacy > Location Services and switch on";
    }
    if (status == INTULocationStatusServicesRestricted) {
        return @"Error: User is restricted from using location services by a usage policy. \nGo to settings > Privacy > Location Services and switch on";
    }
    if (status == INTULocationStatusServicesDisabled) {
        return @"Error: Location services are turned off for all apps on this device.\nGo to settings > Privacy > Location Services and switch on";
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
                                                                          
                                                                              if(self.mapView == nil){
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


-(void)createMapWithCoordinates{
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                            longitude: self.longitude
                                                                 zoom: 17];
    
    self.mapView = [GMSMapView mapWithFrame: self.view.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
//    marker.title = @"New York";
//    marker.snippet = @"USA";
//    marker.map = mapView_;

}

-(void)animateMap{
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
}

// Handle the user's selection. GoogleMap picker.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
//    marker.title = place.name;
//    marker.snippet = place.formattedAddress;
//    marker.map = self.mapView;
    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setSearchBar{
    
    self.searchBar = [[UISearchBar alloc] init];
    
    [self.view addSubview:self.searchBar];
    
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.searchBar.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:14].active = YES;
    [self.searchBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    [self.searchBar setTranslucent:YES];
    
    self.searchBar.userInteractionEnabled = YES;

    self.searchBar.placeholder = @"Search Address";
    self.searchBar.delegate = self;
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
        marker.map = self.mapView;
        
        }

}

-(void)openGooglePlacePicker {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

@end