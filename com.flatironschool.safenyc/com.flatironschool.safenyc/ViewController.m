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
    [self animateMap];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)setUpButtons{
    
    self.widthConstrain = self.view.frame.size.width - 60;
    self.heightConstrain = self.view.frame.size.height - 60;
    self.searchButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 20, 47, 47)];
    self.settingsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 80, 47, 47)];
    self.currentLocationButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 140, 47, 47)];
    self.policeMapButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 200, 47, 47)];
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 260, 47, 47)];
    self.pieChartButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthConstrain, 320, 47, 47)];
    
    NSArray *buttons = @[self.searchButton, self.settingsButton, self.currentLocationButton, self.policeMapButton, self.emergencyButton, self.pieChartButton];
    
    for (DKCircleButton *button in buttons) {

        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        button.backgroundColor = [UIColor whiteColor];
        button.borderColor = [UIColor grayColor];
        button.alpha = 0.8;
        
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
        [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
            [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        }];
        
    } else if (button == self.settingsButton){
        
        [self performSegueWithIdentifier:@"settingsSegue" sender:nil];

        
    } else if (button == self.currentLocationButton){
        
        [self updateCurrentMap];
        
        [self.datastore getCrimeDataWithCompletion:^(BOOL finished) {
            [self updateMapWithCrimeLocations:self.datastore.crimeDataArray];
        }];
        
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
                    NSLog(@"MADE A NEW MAP");

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

    self.marker.position = currentCoordinate;
    self.marker.title = place.name;
    self.marker.snippet = place.formattedAddress;
    self.marker.appearAnimation = kGMSMarkerAnimationPop;
    self.marker.map = self.mapView;
    NSLog(@"marker is now at ======> %f, %f", self.latitude, self.longitude);
    [self animateMap];

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
            self.settingsButton.frame = CGRectMake(self.widthConstrain, 80, 47, 47);
            self.currentLocationButton.frame = CGRectMake(self.widthConstrain, 140, 47, 47);
            self.policeMapButton.frame = CGRectMake(self.widthConstrain, 200, 47, 47);
            self.emergencyButton.frame = CGRectMake(self.widthConstrain, 260, 47, 47);
            self.pieChartButton.frame = CGRectMake(self.widthConstrain, 320, 47, 47);
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

@end