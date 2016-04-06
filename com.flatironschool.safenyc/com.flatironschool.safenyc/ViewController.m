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
#import "PieChartDataViewController.h"
#import "RUFIEmergencyViewController.h"
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
@property (nonatomic) NSUInteger widthConstrain;
@property (nonatomic) NSUInteger heightConstrain;

@end


@implementation ViewController


- (void)viewDidLoad {

    [super viewDidLoad];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance] setTranslucent:YES];

    self.datastore = [RUFIDataStore sharedDataStore];
//    self.activityView =[[UIActivityIndicatorView alloc]init];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(reloadViewAfterSettingsScreen:)
                                                 name:@"Reload Map"
                                               object:nil];
    self.marker = [[GMSMarker alloc]init];
    [self createMapWithCoordinates];
    [self updateCurrentMap];
    [self setUpButtons];
}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:YES];
    [self updateCurrentMap];
    [self updateMapWithPoliceLocation];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpButtons{
    
    self.widthConstrain = self.view.frame.size.width - 60;
    self.heightConstrain = self.view.frame.size.height - 60;
    self.searchButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 20, 47, 47)];
    self.currentLocationButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 80, 47, 47)];
    self.policeMapButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 140, 47, 47)];
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 200, 47, 47)];
    self.pieChartButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 260, 47, 47)];
    self.settingsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 320, 47, 47)];
    
    NSArray *buttons = @[self.searchButton, self.settingsButton, self.currentLocationButton, self.policeMapButton, self.emergencyButton, self.pieChartButton];
    
    for (DKCircleButton *button in buttons) {

        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        button.backgroundColor = [UIColor whiteColor];
        button.borderColor = [UIColor grayColor];
        button.alpha = 1.0;
        
        UIImage *image = [UIImage new];
        if(button == self.searchButton){
            image = [UIImage imageNamed:@"search.png"];
        
        } else if (button == self.settingsButton){
            image = [UIImage imageNamed:@"settings.png"];
            
        } else if (button == self.currentLocationButton){
            image = [UIImage imageNamed:@"currentLocation.png"];
            
        } else if (button == self.policeMapButton){
            image = [UIImage imageNamed:@"policeMap.png"];
            
        } else if (button == self.emergencyButton){
            image = [UIImage imageNamed:@"emergency.png"];
            
        } else if (button == self.pieChartButton){
            image = [UIImage imageNamed:@"pieChart.png"];
            
        }
        button.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [button setImage:image forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeScaleAspectFit];

        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.searchButton){
        
        [self openGooglePlacePicker];
        NSLog(@"Getting to inside the pressed button");
        
    } else if (button == self.settingsButton){
        
        [self performSegueWithIdentifier:@"settingsSegue" sender:nil];

        
    } else if (button == self.currentLocationButton){

        [self updateCurrentMap];
        
    } else if (button == self.policeMapButton){
        
    } else if (button == self.emergencyButton){
        
        [self checkForFingerPrint];
        //[self performSegueWithIdentifier:@"emergencySegue" sender:nil];
       
    } else if (button == self.pieChartButton){
        
        [self performSegueWithIdentifier:@"newSBSegue" sender:nil];
        
    }
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
                    
                    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
                        
                        [self createMapWithCoordinates];
                        [self updateFaceMarker];
                        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
                        
                        
                    }];
                    
                    NSLog(@"MADE A NEW MAP");

                }
                else{
                    
                    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
                        
                        [self animateMap];
                        [self updateFaceMarker];
                        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
                        
                        
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
}

-(void)animateMap{
    
    [self.mapView animateToZoom: 17];
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
    
    
    CLLocationCoordinate2D currentCoordinate = place.coordinate;
    self.latitude = currentCoordinate.latitude;
    self.longitude = currentCoordinate.longitude;
    self.datastore.userLongitude = [NSString stringWithFormat:@"%.6f", self.longitude];
    self.datastore.userLatitude = [NSString stringWithFormat:@"%.6f", self.latitude];
    
    NSLog(@"AT DATA STORE %@", self.datastore.userLatitude);
    NSLog(@"AT DATA STORE %@", self.datastore.userLongitude);
    
    [self.mapView clear];


    NSLog(@"marker is now at ======> %f, %f", self.latitude, self.longitude);
    [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
        [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        
        [self animateMap];
        
        [self updateFaceMarker];
    }];

    
//    self.marker.position = currentCoordinate;
//    self.marker.title = place.name;
//    self.marker.snippet = place.formattedAddress;
//    self.marker.appearAnimation = kGMSMarkerAnimationPop;
//    self.marker.icon = [UIImage imageNamed:@"face"];
//    self.marker.map = self.mapView;
    

    
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
        marker.position = CLLocationCoordinate2DMake(crime.latitude, crime.longitude);
        marker.icon = crime.googleMapsIcon;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.title = crime.offense;
        marker.snippet = [NSString stringWithFormat:@"%@ - %@", crime.precinct, crime.date];
        marker.map = self.mapView;
    }
}


-(void)updateMapWithPoliceLocation{
   
    PoliceDataStore *store = [PoliceDataStore sharedDataStore];
    
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?&name=new+york+city+police+department&location=40.705597,-74.013991&rankby=distance&key=AIzaSyA3sVpYkTVZgOPiV-A0OkDQODMcnVvCYpg
    
//    https://maps.googleapis.com/maps/api/place/nearbysearch/json?name=New+York+City+Police+Department&location=40.705597,-74.013991&key=AIzaSyA3sVpYkTVZgOPiV-A0OkDQODMcnVvCYpg
    
//    40.705475, -74.013993
    
    [store getPoliceLocationsLatitude: 40.705475 Longitude: -74.013993 WithCompletion:^(BOOL finished) {
        
        //this calls the distance API which provides directions (with html tags) on how to get to the
        //police location
        
            if (finished) {
            
                [self getClosestPoliceLocationDirections: store.policeLocationsArray startLatitude: 40.705597  startLongitude:-74.013991 WithCompletion:^(BOOL finished) {
                    
                    if (finished) {
                        NSLog(@"the map should have a damn location set on it!");
                        //call method to mark map with coordinates
                    }
                }];
        
        }
        
        if (finished) {
            
            [self drawClosestPoliceLocationstartLat: 40.705475 startLng: -74.013993 WithPoliceLocation: store.policeLocationsArray];
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
    
    NSLog(@"hrer is your brand new string!!!!: %@", urlString);
    
   AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"origin" : startLatWithLng,
                             @"destination" : destLatWithLng,
                             @"mode" : @"walking",
                             @"waypoints" : waypoints};
   
    [sessionManger GET:aURLstring parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n\n\nhere is the response from the directions API %@", responseObject);
        
        completionBlock(YES);
        

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"here is the error object: %@", error);
            
        completionBlock(NO);
    }];
}

-(void)drawClosestPoliceLocationstartLat:(double)latitude startLng:(double)longitude WithPoliceLocation:(NSArray *)policeLocationsArray{
    
    PoliceLocation *closestPoliceLocation = policeLocationsArray.firstObject;
    
    //origin marker
    GMSMarker *marker = [[GMSMarker alloc]init];
    marker.position = CLLocationCoordinate2DMake(closestPoliceLocation.latitude, closestPoliceLocation.longitude);
//    marker.icon=[UIImage imageNamed:@"aaa.png"] ;
    marker.groundAnchor = CGPointMake(0.5,0.5);
    marker.map = self.mapView;
    
    //2nd marker for destination
    GMSMarker *marker1 = [[GMSMarker alloc]init];
    marker1.position = CLLocationCoordinate2DMake(latitude, longitude);
    //    marker.icon=[UIImage imageNamed:@"aaa.png"] ;
    marker1.groundAnchor = CGPointMake(0.5,0.5);
    marker1.map = self.mapView;

    
    GMSMutablePath *path = [GMSMutablePath path];
    //add destination coord to set marker
    [path addCoordinate: CLLocationCoordinate2DMake(latitude, longitude)];
    [path addCoordinate: CLLocationCoordinate2DMake(closestPoliceLocation.latitude, closestPoliceLocation.longitude)];
//    [path addCoordinate:CLLocationCoordinate2DMake(@(16.7).doubleValue,@(73.8567).doubleValue)];
    GMSPolyline *rectangle = [GMSPolyline polylineWithPath: path];
    rectangle.strokeWidth = 2.f;
    rectangle.map = self.mapView;
    [self animateMap];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   
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
   
}

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
        } else if (isLandscape) {
            self.searchButton.frame = CGRectMake(self.heightConstrain, 20, 47, 47);
            self.settingsButton.frame = CGRectMake(self.heightConstrain, 80, 47, 47);
            self.currentLocationButton.frame = CGRectMake(self.heightConstrain, 140, 47, 47);
            self.policeMapButton.frame = CGRectMake(self.heightConstrain, 200, 47, 47);
            self.emergencyButton.frame = CGRectMake(self.heightConstrain, 260, 47, 47);
            self.pieChartButton.frame = CGRectMake(self.heightConstrain, 320, 47, 47);
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
                                        
                                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"The Access Is Denied!"
                                                                                                       message:@"Emergency button is only for the owner of the phone."
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                              handler:^(UIAlertAction * action) {}];
                                        
                                        [alert addAction:defaultAction];
                                        [self presentViewController:alert animated:YES completion:nil];
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wrong password."
                                                                           message:@"Try again!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}


-(void)updateFaceMarker {
    
    NSUInteger count = self.datastore.crimeDataArray.count;
    
    NSLog(@"Update Face Maker: %lu", count);
    NSLog(@"Update Face Maker DS: %lu", self.datastore.crimeDataArray.count);
    
    GMSMarker *faceMarker = [[GMSMarker alloc] init];
    faceMarker.position = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    
    if (count <= 100) {
        
        faceMarker.icon = [UIImage imageNamed:@"face1"];
        faceMarker.title = [NSString stringWithFormat:@"Total Felonies: %lu", self.datastore.crimeDataArray.count];
        faceMarker.snippet = @"This place doesnt seem that bad!";
        
        NSLog(@"Update Face Maker1: %lu", self.datastore.crimeDataArray.count);
    }
    
    else if (count >= 101 && count <= 400) {
        
        faceMarker.icon = [UIImage imageNamed:@"face2"];
        faceMarker.title = [NSString stringWithFormat:@"Total Felonies: %lu", self.datastore.crimeDataArray.count];
        faceMarker.snippet = @"Everything seems hunky dory.";
        
        NSLog(@"Update Face Maker2: %lu", self.datastore.crimeDataArray.count);
    }
    
    else if (count >= 401 && count <= 700) {
        
        faceMarker.icon = [UIImage imageNamed:@"face3"];
        faceMarker.title = [NSString stringWithFormat:@"Total Felonies: %lu", self.datastore.crimeDataArray.count];
        faceMarker.snippet = @"Ummmmm should I be here?";
        
        NSLog(@"Update Face Maker3: %lu", self.datastore.crimeDataArray.count);
    }
    
    else if (count >= 701 && count <= 1000) {
        
        faceMarker.icon = [UIImage imageNamed:@"face4"];
        faceMarker.title = [NSString stringWithFormat:@"Total Felonies: %lu", self.datastore.crimeDataArray.count];
        faceMarker.snippet = @"Sheesh I better watch my back!";
        
        NSLog(@"Update Face Maker4: %lu", self.datastore.crimeDataArray.count);
    }
    
    else {
        
        faceMarker.icon = [UIImage imageNamed:@"face5"];
        faceMarker.title = [NSString stringWithFormat:@"Total Felonies: %lu", self.datastore.crimeDataArray.count];
        faceMarker.snippet = @"OMG I'm going to die!";
        
        NSLog(@"Update Face Maker5: %lu", self.datastore.crimeDataArray.count);
    }
    


    faceMarker.appearAnimation = kGMSMarkerAnimationPop;
    faceMarker.map = self.mapView;
    
}

@end