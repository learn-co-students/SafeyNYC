//
//  ViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 3/29/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//
#import "ViewController.h"

#import <DKCircleButton/DKCircleButton.h>
#import "PieChartDataViewController.h"
#import "RUFISettingsViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <AFNetworking/AFNetworking.h>


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
@property (strong, nonatomic) DKCircleButton *dissmissPoliceMapButton;
@property (nonatomic) NSUInteger widthConstrain;
@property (nonatomic) NSUInteger heightConstrain;
@property (nonatomic) GMSMarker *faceMarker;
@property (nonatomic) NSUInteger randomInt;
@property (nonatomic) NSUInteger count;
@property (nonatomic) BOOL policeStationActiveBool;

@end


@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    
//    self.latitude = 40.705412;
//    self.longitude = -74.02;
    
//    [self performSegueWithIdentifier:@"introStoryboard" sender:nil];
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 40.705412
//                                                            longitude: -74.013974
//                                                                 zoom: 2];
//    
//    [self.mapView animateToCameraPosition:camera];
//    
//    self.mapView = [GMSMapView mapWithFrame: self.view.bounds camera:camera];
//
//    self.view = self.mapView;
    
    self.datastore = [RUFIDataStore sharedDataStore];
    self.datastore.distanceInMeters = @"402";
    self.datastore.distanceInMiles = @"1/4";
    self.datastore.yearsAgo = @"2";
    self.datastore.distanceValue = @"2";

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(reloadViewAfterSettingsScreen:)
                                                 name:@"Reload Map"
                                               object:nil];
    self.marker = [[GMSMarker alloc]init];
    self.currentLocationButton.enabled = YES;
    [self createMapWithCoordinates];
    [self updateCurrentMap];
    [self setUpButtons];
    [self disableAllButtons];
    
//    if (![self checkPasswordFieldExsists]) {
//        [self alertWithPasswordEntryForFirstTime];
//    }
    
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    
    if (self.datastore.settingsChanged){
        
        [self disableAllButtons];
    
        [self updateMapAfterSetttingsChange];
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpButtons{
    
    self.widthConstrain = self.view.frame.size.width - 60;
    self.heightConstrain = self.view.frame.size.height - 60;
    NSLog(@"Width: %lu", self.widthConstrain);
    self.searchButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 35, 47, 47)];
    self.currentLocationButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 95, 47, 47)];
    self.policeMapButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 155, 47, 47)];
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 215, 47, 47)];
    self.pieChartButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 275, 47, 47)];
    self.settingsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 335, 47, 47)];
    //self.infoButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 395, 47, 47)];
    self.dissmissPoliceMapButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, self.heightConstrain, 47, 47)];
    
    NSArray *buttons = @[self.searchButton, self.currentLocationButton, self.policeMapButton, self.emergencyButton, self.pieChartButton, self.settingsButton, self.dissmissPoliceMapButton];
    
    for (DKCircleButton *button in buttons) {

        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        button.backgroundColor = [UIColor whiteColor];
        button.borderColor = [UIColor lightGrayColor];
        button.alpha = 1;
        
        UIImage *image = [UIImage new];
        if(button == self.searchButton){
            image = [UIImage imageNamed:@"search.png"];
        
        } else if (button == self.currentLocationButton){
            image = [UIImage imageNamed:@"currentLocation.png"];
            
        } else if (button == self.policeMapButton){
            image = [UIImage imageNamed:@"policeMap.png"];
            
        } else if (button == self.emergencyButton){
            image = [UIImage imageNamed:@"emergency.png"];
            
        } else if (button == self.pieChartButton){
            image = [UIImage imageNamed:@"pieChart.png"];
            
        } else if (button == self.dissmissPoliceMapButton){
            image = [UIImage imageNamed:@"cancel"];
            
        } else if (button == self.settingsButton){
            image = [UIImage imageNamed:@"settings.png"];
            
        } /*else if (button == self.infoButton){
            image = [UIImage imageNamed:@"info"];
            
        }*/
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [button setImage:image forState:UIControlStateNormal];
        //[button setContentMode:UIViewContentModeScaleAspectFit];

        button.animateTap = NO;
        self.dissmissPoliceMapButton.hidden = YES;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    NSLog(@"disabled!!!!!");
    
//    if ([self haveInternetConnection]) {
    
    if(button == self.searchButton){
        
        NSLog(@"BUTTON TAPPED");
        [self openGooglePlacePicker];
        
        NSLog(@"Getting to inside the pressed button");
        
        
    } else if (button == self.settingsButton){
        NSLog(@"BUTTON TAPPED");
        //[self displayPicker];
        
        [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
        
    } else if (button == self.currentLocationButton){
        NSLog(@"BUTTON TAPPED");
        
        self.randomInt = arc4random_uniform(1000);
        
        if (self.policeStationActiveBool && !self.searchLocation) {
            
            NSLog(@"\n\n\n\n\n\n\n\n\nPOLICE ACTIVE SEARCH NOT\n\n\n\n\n\n\n\n\n");
            
            [self updateMapWithPoliceLocation];
            
        }
        
        else if (self.searchLocation) {

            NSLog(@"\n\n\n\n\n\n\n\n\nSEARCH ACTIVE\n\n\n\n\n\n\n\n\n");
            
            [self disableAllButtons];
            
            self.searchLocation = NO;
            self.policeStationActiveBool = NO;
            
            [self updateCurrentMap];
            
        }
        
        else {
            
            NSLog(@"\n\n\n\n\n\n\n\n\nNOTHIING ACTIVE\n\n\n\n\n\n\n\n\n");
            
            
            [self disableAllButtons];
            
            [self updateCurrentMap];
            
        }
        
    } else if (button == self.policeMapButton){

        NSLog(@"BUTTON TAPPED");
        [self disableAllButtons];
        
        self.policeStationActiveBool = YES;
        
        [self updateMapWithPoliceLocation];
        
        self.dissmissPoliceMapButton.hidden = NO;
        
        
    }  else if (button == self.emergencyButton){

        NSLog(@"BUTTON TAPPED");
        
        [self checkForFingerPrint];
        //[self performSegueWithIdentifier:@"emergencySegue" sender:nil];
        
    }
    else if (button == self.pieChartButton){
        NSLog(@"BUTTON TAPPED");
        [self performSegueWithIdentifier:@"newSBSegue" sender:nil];
        
    } else if (button == self.dissmissPoliceMapButton){
        NSLog(@"BUTTON TAPPED");
        
        //        [self dissmissPoliceMapButton];
        [self dissmissPoliceMap];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                                longitude: self.longitude
                                                                     zoom: 17];
        
        [self.mapView animateToCameraPosition:camera];
        [self.mapView animateToViewingAngle:65];
        
        
        //        [self.mapView animateToLocation: CLLocationCoordinate2DMake(self.latitude, self.longitude)];
        
    }
    
    NSLog(@"reenabled!!!!!");
        
//        }
//else if (button == self.emergencyButton){
//    
//                NSLog(@"BUTTON TAPPED");
//    
//                [self checkForFingerPrint];
//                //[self performSegueWithIdentifier:@"emergencySegue" sender:nil];
//    
//        } else{
//    
//                [self failedToGetLocation];
//        }
    
    
}

-(void)dissmissPoliceMap{

    self.dissmissPoliceMapButton.hidden = YES;
    self.policeStationActiveBool = NO;
    [self removeClosetPoliceLocation];

}

-(void)openGooglePlacePicker {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
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
                    
                    [self startSpinner];
                    
                    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
                        
                        [self createMapWithCoordinates];
                        
                        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        
                        [self updateFaceMarker];
                        
                        [self endSpinner];
                        
                        NSLog(@"CALL ENDED");
                        
                    }];
                    
                    NSLog(@"MADE A NEW MAP");

                }
                else if(!success) {
                
                    [self endSpinner];
                    [self failedToGetLocation];
                
                
                }
                else{
                    
                    
                    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
                        
                        [self startSpinner];

                        [self.mapView clear];
                        
                        [self.dissmissPoliceMapButton setHidden: YES];
                    
                        [self animateMap];

                        [self updateFaceMarker];
                        
                        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
                        
                        [self endSpinner];
                        
                        [self reenableAllButtons];
                    
                    }];
                    
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

-(void)failedToGetLocation{

    [self disableAllButtons];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Oh NO! Something weird happened. \nPlease make sure your connected to the internet or \nhave Wi-Fi enabled"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: nil];
    
    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];

}

- (NSString *)getLocationErrorDescription:(INTULocationStatus)status
{

//    INTULocationStatusSuccess = 0,
//    /** Got a location, but the desired accuracy level was not reached before timeout. (Not applicable to subscriptions.) */
//    INTULocationStatusTimedOut,
//    
//    // These statuses indicate some sort of error, and will accompany a nil location.
//    /** User has not yet responded to the dialog that grants this app permission to access location services. */
//    INTULocationStatusServicesNotDetermined,
//    /** User has explicitly denied this app permission to access location services. */
//    INTULocationStatusServicesDenied,
//    /** User does not have ability to enable location services (e.g. parental controls, corporate policy, etc). */
//    INTULocationStatusServicesRestricted,
//    /** User has turned off location services device-wide (for all apps) from the system Settings app. */
//    INTULocationStatusServicesDisabled,
//    /** An error occurred while using the system location services. */
//    INTULocationStatusError
//    
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
    if (status == INTULocationStatusError) {
        return @"An error occured while using your devices location services.\nPlease check your location services.\nGo to settings > Privacy > Location Services and switch on";
    }
    
    return @"An unknown error occurred. Please make sure you have internet enabled.";
}

- (void)updateCurrentLocationCoordinatesWithBlock:(void (^) (BOOL success))block {
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    
    [locMgr requestLocationWithDesiredAccuracy: INTULocationAccuracyRoom timeout: 1.5 delayUntilAuthorized: NO block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        
        if (status == INTULocationStatusSuccess) {
            
            self.longitude = currentLocation.coordinate.longitude;
            self.datastore.userLongitude = [NSString stringWithFormat:@"%.6f", self.longitude];
            self.latitude = currentLocation.coordinate.latitude;
            self.datastore.userLatitude = [NSString stringWithFormat:@"%.6f", self.latitude];
            NSLog(@"COORDS WITH BLOCK FINISHES AND RESETS CURRENT LOCATION");
            block(YES);

        }
        
        else if(status == INTULocationStatusTimedOut){
            
            self.longitude = currentLocation.coordinate.longitude;
            self.datastore.userLongitude = [NSString stringWithFormat:@"%.6f", self.longitude];
            self.latitude = currentLocation.coordinate.latitude;
            self.datastore.userLatitude = [NSString stringWithFormat:@"%.6f", self.latitude];
            block(YES);

        }
        else if(status == INTULocationStatusServicesNotDetermined || !self.mapView){
        
            block(NO);
        }
        else if(status == INTULocationStatusError){
            
            block(NO);
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
                                                                                  [self reenableAllButtons];
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
        
    }];
    
}


-(void)createMapWithCoordinates{
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
//                                                            longitude: self.longitude
//                                                                 zoom: 17];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: 40.705412
                                                            longitude: -74.013974
                                                                 zoom: 12 bearing:0 viewingAngle:0];
    
    self.mapView = [GMSMapView mapWithFrame: self.view.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;

    self.view = self.mapView;
}

-(void)animateMap{
    
    [self.mapView animateToLocation:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    [self.mapView animateToViewingAngle:65];
    [self.mapView animateToZoom:17];

}

// Handle the user's selection. GoogleMap picker.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    
    [self disableAllButtons];
    self.randomInt = arc4random_uniform(1000);
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    CLLocationCoordinate2D currentCoordinate = place.coordinate;
    self.latitude = currentCoordinate.latitude;
    self.longitude = currentCoordinate.longitude;
    self.datastore.userLongitude = [NSString stringWithFormat:@"%.6f", self.longitude];
    self.datastore.userLatitude = [NSString stringWithFormat:@"%.6f", self.latitude];
    self.searchLocation = YES;
    self.policeStationActiveBool = NO;
    self.dissmissPoliceMapButton.hidden = YES;
    
    
    NSLog(@"AT DATA STORE %@", self.datastore.userLatitude);
    NSLog(@"AT DATA STORE %@", self.datastore.userLongitude);

       [self.mapView clear];
    
        [self startSpinner];
    NSLog(@"marker is now at ======> %f, %f", self.latitude, self.longitude);
    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        
        [self animateMap];
        
        [self updateFaceMarker];

        [self endSpinner];
        
        [self reenableAllButtons];
    
    }];

}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %li", [error code]);
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
        CLLocationDegrees degrees = 0;
        marker.position = CLLocationCoordinate2DMake(crime.latitude, crime.longitude);
        marker.icon = crime.googleMapsIcon;
        marker.groundAnchor = CGPointMake(0.5, 0.5);
        marker.rotation = degrees;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = crime.offense;
        marker.flat = NO;
        marker.snippet = [NSString stringWithFormat:@"%@ - %@", crime.precinct, crime.date];
        marker.map = self.mapView;

    }

}

-(void)updateMapWithPoliceLocation{
   
    [self startSpinner];
    
    [self disableAllButtons];
    
    [self.mapView clear];
    
    [self updateFaceMarker];
    
    self.policeStationActiveBool = YES;
    PoliceDataStore *store = [PoliceDataStore sharedDataStore];
//    40.705475, -74.013993

    
    [store getPoliceLocationsLatitude: self.latitude Longitude: self.longitude WithCompletion:^(BOOL finished) {
        
        //this calls the distance API which provides directions (with html tags) on how to get to the
        //police location
        
            if (finished) {
            
                [self getClosestPoliceLocationDirections: store.policeLocationsArray startLatitude: self.latitude  startLongitude: self.longitude WithCompletion:^(BOOL finished) {
                    
                    if (finished) {
                
                        [self reenableAllButtons];
                        NSLog(@"let's draw a line!!!!!!!!!!");
                        [self endSpinner];
                        
                        if (self.searchLocation) {
                            self.policeLocationFoundForActualCurrentLocation = NO;
                        }
                        else{
                            self.policeLocationFoundForActualCurrentLocation = YES;
                        }

                        [self endSpinner];
                    }
                    
                }];
        
        }
        else if([store getCurrentPoliceLocationsCount] == 0){
            
            [self reenableAllButtons];
            [self dissmissPoliceMap];
            [self endSpinner];
            
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No Locations Found"
                                                                               message:@"No police locations nearby"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler: nil];
                
                [alert addAction:defaultAction];
                
                [self presentViewController:alert animated:YES completion:nil];

            }
            else{
            
                [self endSpinner];
                [self failedToGetLocation];

            }
        
    }];
     
}

-(void)getClosestPoliceLocationDirections:(NSArray *)policeLocationsArray
                  startLatitude:(double) latitude
                 startLongitude:(double) longitude
                 WithCompletion:(void (^)(BOOL finished))completionBlock{

    PoliceLocation *closestPoliceLocation = policeLocationsArray.firstObject;
//    Latitude: 40.705597 Longitude: -74.013991
    
    NSString *startLatWithLng = [NSString stringWithFormat: @"%f,%f", latitude, longitude];
    NSString *destLatWithLng = [NSString stringWithFormat: @"%f,%f", closestPoliceLocation.latitude, closestPoliceLocation.longitude];
    
    NSLog(@" start coords: %@", startLatWithLng);
    NSLog(@" end coords: %@", destLatWithLng);

    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=walking&waypoints=%@|%@",startLatWithLng, destLatWithLng, startLatWithLng, destLatWithLng];
    
    NSString *aURLstring = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?"];
    NSString *waypoints = [NSString stringWithFormat:@"%@|%@",startLatWithLng,destLatWithLng];
    
    NSLog(@"here is your brand new string!!!!: %@", urlString);
    
   AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"origin" : startLatWithLng,
                             @"destination" : destLatWithLng,
                             @"mode" : @"walking",
                             @"waypoints" : waypoints};
   
    [sessionManger GET:aURLstring parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n\n\nhere is the response from the directions API %@", responseObject);
        
        GMSPath *path = [GMSPath pathFromEncodedPath: responseObject[@"routes"][0][@"overview_polyline"][@"points"]];
        
        [self drawClosetPoliceLocationWithPath: path startLat: latitude startLng: longitude policeLocation: closestPoliceLocation];

        
        completionBlock(YES);
        

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"here is the error object: %@", error);
    
        completionBlock(NO);
    }];
}

-(void)drawClosetPoliceLocationWithPath:(GMSPath *)path
                               startLat:(double) startLatitude
                               startLng:(double) startLongitude
                         policeLocation:(PoliceLocation *)policeLocation{
    
    double endLatitude = policeLocation.latitude;
    double endLongitude = policeLocation.longitude;
    
    if (self.policePolyline && self.policeMarker) {
        
        NSLog(@"cleared the map of the police line and its marker!!!!!");
        [self removeClosetPoliceLocation];
    }

    self.policePolyline = [GMSPolyline polylineWithPath: path];
//    [UIColor colorWithRed:0.353 green:0.38 blue:0.659 alpha:1];
    self.policePolyline.strokeColor = [UIColor redColor];
    self.policePolyline.strokeWidth = 5.f;
    self.policePolyline.map = self.mapView;
    

    self.policeMarker = [[GMSMarker alloc]init];
    self.policeMarker.position = CLLocationCoordinate2DMake(endLatitude, endLongitude);
    self.policeMarker.icon = [UIImage imageNamed:@"policeStation"] ;
    self.policeMarker.title = policeLocation.locationName;
    self.policeMarker.snippet = policeLocation.locationAddress;
    self.policeMarker.groundAnchor = CGPointMake(0.5,0.5);
    self.policeMarker.map = self.mapView;
    
    [self.mapView animateToLocation: CLLocationCoordinate2DMake(endLatitude, endLongitude)];
    
    //thinking about adding more to this feature for presentation purposes..
    //[self zoomOnPoliceLocationBackToCurrentLocationWithPath: path];
    
    [self zoomOnPoliceLocation: CLLocationCoordinate2DMake(endLatitude, endLongitude)];
}

//-(void)zoomOnPoliceLocationBackToCurrentLocationWithPath:(GMSPath *) path{
//
//       NSUInteger pathEndPoint = path.count - 1;
//    
//    //    - (CLLocationCoordinate2D)coordinateAtIndex:(NSUInteger)index;
//        CLLocationCoordinate2D currentPoint;
//    //    NSLog(@"end point is currently: %@", pathEndPoint);
//    
//        for (NSInteger idx = pathEndPoint; idx > 0; idx--) {
//            NSLog(@"we are now here!!!!");
//            currentPoint = [path coordinateAtIndex: idx];
//            NSLog(@"idx is now: %ld", (long)idx);
//    //        [self.mapView animateToLocation: currentPoint];
//    
//            double delayInSeconds = .9;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self.mapView animateToLocation: currentPoint];
//            });
//    
//        }
//
//}

-(void)zoomOnPoliceLocation:(CLLocationCoordinate2D )policeLocation{
    
    CLLocationCoordinate2D origin = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    CLLocationCoordinate2D policeCoods = CLLocationCoordinate2DMake(policeLocation.latitude, policeLocation.longitude);

        GMSCoordinateBounds *bounds = [ [GMSCoordinateBounds alloc] initWithCoordinate: origin coordinate: policeCoods];
    
    
   [self.mapView moveCamera: [GMSCameraUpdate fitBounds: bounds withPadding: 100.0f]];

}



-(void)removeClosetPoliceLocation{
    
    [self.policePolyline setMap:nil];
    [self.policeMarker setMap: nil];
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

   
    /*
    switch(segueName){
        case 'settingsSegue' :
            NSLog(@"settingSegue");
            break;
        case 'newSBSegue' :
            NSLog(@"settingSegue");
            break;
            //PieChartDataViewController *pieChartVC = segue.destinationViewController;
            //pieChartVC.transitionCoordinator =
        case 'emergencySegue' :
            NSLog(@"emergencySegue");
            break;
        default:
            NSLog(@"another button");
            
    }*/
   
//}

#pragma mark - Transition to Size
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    BOOL isPortrait = size.height > size.width;
    BOOL isLandscape = size.width > size.height;
   
    [UIView animateWithDuration:0.3f animations:^{
        
        if(isPortrait){
           
            self.searchButton.frame = CGRectMake(self.widthConstrain, 20, 47, 47);
            self.currentLocationButton.frame = CGRectMake(self.widthConstrain, 80, 47, 47);
            self.policeMapButton.frame = CGRectMake(self.widthConstrain, 140, 47, 47);
            self.emergencyButton.frame = CGRectMake(self.widthConstrain, 200, 47, 47);
            self.pieChartButton.frame = CGRectMake(self.widthConstrain, 260, 47, 47);
            self.settingsButton.frame = CGRectMake(self.widthConstrain, 320, 47, 47);
            //self.infoButton.frame = CGRectMake(self.widthConstrain, 380, 47, 47);
            self.dissmissPoliceMapButton.frame = CGRectMake(self.widthConstrain, self.heightConstrain, 47, 47);
       
        } else if (isLandscape) {
        
            //We are not displaying pid cart and setting in the Landscape Mode!
            self.searchButton.frame = CGRectMake(self.heightConstrain, 20, 47, 47);
            self.currentLocationButton.frame = CGRectMake(self.heightConstrain, 80, 47, 47);
            self.policeMapButton.frame = CGRectMake(self.heightConstrain, 140, 47, 47);
            self.emergencyButton.frame = CGRectMake(self.heightConstrain, 200, 47, 47);
            self.pieChartButton.frame = CGRectMake(self.heightConstrain, 260, 47, 47);
            self.settingsButton.frame = CGRectMake(self.heightConstrain, 320, 47, 47);
            //self.infoButton.frame = CGRectMake(self.heightConstrain, 260, 47, 47);
            self.dissmissPoliceMapButton.frame = CGRectMake(self.heightConstrain, 320, 47, 47);
            
        }
        [self.view layoutIfNeeded];
    }];
}

# pragma mark - touch id
-(void)checkForFingerPrint{
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Touch ID is ready. Your print can be used for unlocking emergency button!";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self performSegueWithIdentifier:@"emergencySegue" sender:nil];
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{

                                        //check type of error here
                                        switch (error.code) {
                                                
                                            case LAErrorAuthenticationFailed:
                                                
                                                NSLog(@"Authentication Failed");
                                                
                                                break;
                                                
                                            case LAErrorUserCancel:
                                                NSLog(@"User pressed Cancel button");
                                                break;
                                                
                                            case LAErrorUserFallback:
                                                if ([self checkPasswordFieldExsists]) {
                                                    [self alertWithPasswordEntry];
                                                }
                                                else{
                                                    [self alertWithPasswordEntryForFirstTime];
                                                }
                                                NSLog(@"User pressed \"Enter Password\"");
                                                break;
                                                
                                            default:
                                                NSLog(@"Touch ID is not configured");
                                                break;
                                        }

                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter Password"
                                                                           message:@"Would you like to enter a password?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      if ([self checkPasswordFieldExsists]) {
                                                                          [self alertWithPasswordEntry];
                                                                      }
                                                                      else{
                                                                          [self alertWithPasswordEntryForFirstTime];
                                                                      }
                                                                  }];
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style: UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * action) {

                                                                  }];

            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];

            [alert.view setNeedsLayout];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)alertWithPasswordEntryForFirstTime{

    NSString *passwordMessage = @"Safey NYC uses TouchID for accessing our messaging feature.\nPlease enter a password as an alternative means of access.\n(Password must be at least 4 characters)\n";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Setup Password"
                                                                   message: passwordMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        [textField addTarget:self
                      action:@selector(alertTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
//        [textField becomeFirstResponder];

    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         NSString *userPassword = alert.textFields.firstObject.text;
                                                         
                                                         if (![self checkPasswordFieldExsists]) {
                                                            [self savePassword: userPassword];
                                                         }

//                                                         [alert.textFields.firstObject resignFirstResponder]; 

                                                     }];
    [alert addAction: okAction];
    
    
    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = sender.text.length > 3;
    }
}

-(BOOL)passwordIsValid:(NSString *)userPassword{

    BOOL passwordValid = (userPassword.length > 3) && userPassword;
    
    return passwordValid;

}

-(void)alertWithPasswordEntry{
    
    NSString *passwordMessage = @"Please enter your password: ";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enter Password"
                                                                   message: passwordMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         
                                                         NSString *userPassword = alert.textFields.firstObject.text;
                                                         
                                                         if ([self checkPasswordFieldExsists]) {
                                                             [self checkForPassword: userPassword];

                                                         }

                                                     }];
//    
//    UIAlertAction* forgotPassAction = [UIAlertAction actionWithTitle:@"Forgot Password" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * action) {
//
//                                                         //insert code to handle password
//                                                         [self forgotPassword];
//                                                         
//                                                     }];
    
    [alert addAction: okAction];
    
//    if (passwordExists) {
//        [alert addAction: forgotPassAction];
//    }
    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];


}

//-(void)forgotPassword{
//
//    //will present a few questions for the user to answer for the purpose of
//    //recovering a password
//    
////        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
////        BOOL userCreated = [defaults boolForKey: @"userCreated"];
////    
////        if (!userCreated) {
////    
////            [defaults setBool: YES forKey: @"userCreated"];
////            
////            
////            
////        }
//    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Question1"
//                                                                   message: @"what's your fucking name?"
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"enter your fucking name";
//    }]; 
//    
//    UIAlertAction* nextAction = [UIAlertAction actionWithTitle:@"next question" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * action) {
//                                                         
//                                                         
//                                                         
//                                                     }];
//    
//    UIAlertAction* forgotPassAction = [UIAlertAction actionWithTitle:@"Forgot Password" style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//                                                                 
//                                                                 //insert code to handle password
//                                                                 [self forgotPassword];
//                                                                 
//                                                             }];
//    
//    [alert addAction: okAction];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//
//    
//    
//}

//-(void)setupUserPasswordVerification{

//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL userCreated = [defaults boolForKey: @"userCreated"];
//    
//    if (!userCreated) {
//        
//        [defaults setBool: forKey: @"userCreated"];
//        [defaults setValue: @"" forKey: @"question1"];
//        [defaults setValue: @"" forKey: @"question2"];
//        [defaults setValue: @"" forKey: @"question3"];
//        
//    }
//
//
//    
//    [defaults synchronize];



//}

//-(void)presentQuestions{

//
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Security Questions"
//                                                                   message:
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Password";
//        textField.secureTextEntry = YES;
//    }];
//    
//    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                     handler:^(UIAlertAction * action) {
//                                                         
//                                                         NSString *userPassword = alert.textFields.firstObject.text;
//                                                         
//                                                         [self checkForPassword: userPassword];
//                                                         
//                                                     }];
//    
//    UIAlertAction* forgotPassAction = [UIAlertAction actionWithTitle:@"Forgot Password" style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action) {
//                                                                 
//                                                                 //insert code to handle password
//                                                                 
//                                                                 
//                                                             }];
//    [alert addAction: okAction];
//    [alert addAction: forgotPassAction];
//    
//    
//    [self presentViewController:alert animated:YES completion:nil];
//



//}



-(BOOL)checkPasswordFieldExsists{
    
    NSLog(@"\n\n\nUP IN HURRRRRRRRRRRRR\n\n\n");

    BOOL hasPasswordField = NO;
    
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"SafeyNYC1"];
    keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;

    
    NSLog(@"\n\n\nabout to check them keys boy......\n\n\n");
    NSArray *allKeys = keychain.allKeys;
    NSLog(@"\n\n\n\nhere's what's in the keychain%@", keychain);
    
    for (NSString *key in allKeys) {
        
        if ([key isEqualToString: @"password1"]) {
            NSLog(@"found the damn key in keychain!!!!!!");
            hasPasswordField = YES;
            break;
        }
    }
    
    return hasPasswordField;
}

-(void)savePassword:(NSString *)userPassword{

    if(![self checkPasswordFieldExsists]){
        
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"SafeyNYC1"];
        keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //[keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
                  //authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                keychain[@"password1"] = userPassword;
                NSLog(@"we just saved the password!!!!!");
                
                
            }];
            
        });

        
//        [keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
//              authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
//        
//        //create the password key
//        keychain[@"password"] = userPassword;
//        NSLog(@"we just saved the password!!!!!");
        
    }
    
    
    
   

}

-(void)checkForPassword:(NSString *)userPassword{

    if([self checkPasswordFieldExsists]){
        
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"SafeyNYC1"];
        keychain.accessibility = UICKeyChainStoreAccessibilityWhenUnlocked;

        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //[keychain setAccessibility:UICKeyChainStoreAccessibilityWhenPasscodeSetThisDeviceOnly
                 // authenticationPolicy:UICKeyChainStoreAuthenticationPolicyUserPresence];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                
                NSString *passwordCheck = keychain[@"password1"];
                NSLog(@"entered password: %@", passwordCheck);
                NSLog(@"actual password is: %@", keychain[@"password1"]);
                
                if ([passwordCheck isEqualToString: userPassword]) {
                    NSLog(@"correct password entered!!!");
                    [self performSegueWithIdentifier:@"emergencySegue" sender:nil];
                    
                }
                else{
                    //password doesnt exsist....handle this.......
                    NSLog(@"NOOOOOOOOO....incorrect password");
                    [self incorrectPasswordPrompt];
                }

            }];
            
        });
        
        
//        if ([passwordCheck isEqualToString: userPassword]) {
//            NSLog(@"correct password entered!!!");
//            [self performSegueWithIdentifier:@"emergencySegue" sender:nil];
//
//        }
//        else{
//            //password doesnt exsist....handle this.......
//            NSLog(@"NOOOOOOOOO....incorrect password");
//            [self incorrectPasswordPrompt];
        
        }

}


-(void)incorrectPasswordPrompt{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incorrect Password"
                                                                   message: @"Incorrect password, please try again"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {

                                                         [self alertWithPasswordEntry];
                                                     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addAction: okAction];
    [alert addAction: cancelAction];

    [alert.view setNeedsLayout];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)updateFaceMarker {
    
    NSLog(@"getting here from police button");
    
    if (self.randomInt !=13) {

    self.count = self.datastore.crimeDataArray.count / [self.datastore.yearsAgo integerValue] / [self.datastore.distanceValue integerValue];
    
    self.faceMarker = [[GMSMarker alloc] init];
    self.faceMarker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    if (self.count <= 25) {
        
        self.faceMarker.icon = [UIImage imageNamed:@"face1"];
        self.faceMarker.snippet = [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
        
        
        self.faceMarker.title = @"This place doesnt seem that bad!";
        
        NSLog(@"Update Face Maker1: %lu", (unsigned long)self.datastore.crimeDataArray.count);
    }
    
    else if (self.count >= 26 && self.count <= 100) {
        
        self.faceMarker.icon = [UIImage imageNamed:@"face2"];
        self.faceMarker.snippet= [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
        self.faceMarker.title = @"Everything seems hunky dory.";
        
        NSLog(@"Update Face Maker2: %lu", (unsigned long)self.datastore.crimeDataArray.count);
    }
    
    else if (self.count >= 101 && self.count <= 175) {
        
        self.faceMarker.icon = [UIImage imageNamed:@"face3"];
        self.faceMarker.snippet = [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
        self.faceMarker.title  = @"Ummmmm should I be here?";
        
        NSLog(@"Update Face Maker3: %lu", (unsigned long)self.datastore.crimeDataArray.count);
    }
    
    else if (self.count >= 176 && self.count <= 250) {
        
        self.faceMarker.icon = [UIImage imageNamed:@"face4"];
        self.faceMarker.snippet = [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
        self.faceMarker.title = @"Sheesh I better watch my back!";
        
        NSLog(@"Update Face Maker4: %lu", (unsigned long)self.datastore.crimeDataArray.count);
    }
    
    else {
        
        self.faceMarker.icon = [UIImage imageNamed:@"face5"];
        self.faceMarker.snippet = [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
        self.faceMarker.title = @"OMG! I'm going to die!";

        
        NSLog(@"Update Face Maker5: %lu", (unsigned long)self.datastore.crimeDataArray.count);
    }
    
    
    self.faceMarker.appearAnimation = kGMSMarkerAnimationPop;

    self.faceMarker.map = self.mapView;
        
    }
    
    else {
        
        [self generateSuperHero];
        
    }
    
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]  isEqualToString: @"emergencySegue"]){
        
        RUFIEmergencyViewController *emergencyVC = (RUFIEmergencyViewController *)segue.destinationViewController;
//        RUFIEmergencyViewController *root = emergencyVC.viewControllers.firstObject;
        
        emergencyVC.myCurrnetLongitude = (double)self.latitude;
        emergencyVC.myCurrnetLatitude = (double)self.longitude;

    }
}


-(void)updateMapAfterSetttingsChange {
    
    [self.mapView clear];
    [self startSpinner];
    NSLog(@"marker is now at ======> %f, %f", self.latitude, self.longitude);
    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        
        [self animateMap];
        
        [self updateFaceMarker];
        
        [self reenableAllButtons];
        
        self.datastore.settingsChanged = NO;
        
        self.dissmissPoliceMapButton.hidden = YES;
        
        NSLog(@"settings finished updating!!!!!");
    [self endSpinner];
    
    }];
    
    
}


//UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
//spinner.color = [UIColor blueColor];
//[spinner startAnimating];
//[_mapViewController.view addSubview:spinner];
//
//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    // lots of code run in the background
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // stop and remove the spinner on the main thread when done
//        [spinner removeFromSuperview];
//    });
//});

-(void)startSpinner{

    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    
    self.spinner.color = [UIColor whiteColor];

    NSLog(@"spinner made");
    [self.spinner startAnimating];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mapView addSubview: self.spinner];
    [self.spinner.centerXAnchor constraintEqualToAnchor: self.mapView.centerXAnchor].active = YES;
    [self.spinner.centerYAnchor constraintEqualToAnchor: self.mapView.centerYAnchor].active = YES;


}

-(void)endSpinner{

    if (self.spinner.isAnimating) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
        NSLog(@"spinner destoryed");
    }
}


-(void)disableAllButtons {
    
    self.searchButton.enabled = NO;
    self.searchButton.enabled = NO;
    self.settingsButton.enabled = NO;
    self.currentLocationButton.enabled = NO;
    self.policeMapButton.enabled = NO;
    self.emergencyButton.enabled = NO;
    self.pieChartButton.enabled = NO;
    self.dissmissPoliceMapButton.enabled = NO;
    
}

-(void)reenableAllButtons {
    
    self.searchButton.enabled = YES;
    self.settingsButton.enabled = YES;
    self.currentLocationButton.enabled = YES;
    self.policeMapButton.enabled = YES;
    self.emergencyButton.enabled = YES;
    self.pieChartButton.enabled = YES;
    self.dissmissPoliceMapButton.enabled = YES;
    
}

-(void)generateSuperHero {
    NSUInteger superHeroInt = arc4random_uniform(6);
    self.count = self.datastore.crimeDataArray.count / [self.datastore.yearsAgo integerValue] / [self.datastore.distanceValue integerValue];
    self.faceMarker = [[GMSMarker alloc] init];
    self.faceMarker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    NSArray *heros = @[[UIImage imageNamed:@"batman"], [UIImage imageNamed:@"daredevil"], [UIImage imageNamed:@"deadpool"], [UIImage imageNamed:@"ironman"], [UIImage imageNamed:@"superman"], [UIImage imageNamed:@"spider"]];
    NSArray *sayings = @[@"This must be the clown's doing!", @"I must protect my city!", @"Crime much?", @"Cap? Hulk? Thor?", @"Lois is in trouble!", @"With great power..."];
    self.faceMarker.icon = heros[superHeroInt];

    self.faceMarker.title = sayings[superHeroInt];
    
    NSLog(@"%lu", superHeroInt);
    
    self.faceMarker.snippet = [NSString stringWithFormat:@"Total Felonies: %lu", (unsigned long)self.datastore.crimeDataArray.count];
    
    self.faceMarker.appearAnimation = kGMSMarkerAnimationPop;
    self.faceMarker.map = self.mapView;
}

-(BOOL)haveInternetConnection{

    return [Utils isNetworkAvailable];
    

}

/*
# pragma mark - Settings
-(void) displayPicker {
    
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    RUFISettingsViewController *settingsVC = [settingsStoryboard instantiateInitialViewController];
    settingsVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:settingsVC animated:YES completion:nil];
//    
//    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(20, 185, self.widthConstrain+20, 200)];
//
//    pickerView.backgroundColor = [UIColor whiteColor];
//    pickerView.layer.cornerRadius = 20;
//    
//    [UIView animateWithDuration:0.5 animations:^(void) {
//        pickerView.alpha = 0;
//        
//        [UIView transitionWithView:pickerView duration:3
//                           options:UIViewAnimationOptionTransitionFlipFromRight
//                        animations:^{
//                            [self.view addSubview:pickerView];
//                        }
//                        completion:^(BOOL finished){
//                            
//                        }];
//        
//        pickerView.alpha = 0.8;
//    }];
//    pickerView.userInteractionEnabled = YES;
//    
//    [self disableAllButtons];

}*/


@end