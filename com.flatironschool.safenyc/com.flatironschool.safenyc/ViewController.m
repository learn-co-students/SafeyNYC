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

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.longitude = -74.014002;
    self.latitude = 40.805443;
    
    [self promptForLocationServices];
    
    [self updateMap];
    
    //[self setSearchBar];

    [self setUpButtons];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self findTheCurrentLocation];
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
    
    NSArray *buttons = @[self.searchButton, self.settingsButton, self.currentLocationButton, self.policeMapButton, self.emergencyButton];
    
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


-(void)updateMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: self.latitude
                                                            longitude: self.longitude
                                                                 zoom: 17];
    
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
}


-(void)findTheCurrentLocation{
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
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

-(void)openGooglePlacePicker {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

@end