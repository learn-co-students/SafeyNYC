//
//  RUFISettingsViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/3/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFISettingsViewController.h"
#import <DKCircleButton/DKCircleButton.h>
#import "RUFIEmergencyViewController.h"
#import "RUFIDataStore.h"


@interface RUFISettingsViewController ()
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSArray *radiusArray;
@property (strong, nonatomic) NSArray *yearsArray;
@property (strong, nonatomic) UILabel *changeRadiusLabel;
@property (strong, nonatomic) UILabel *milesLabel;
@property (strong, nonatomic) UILabel *yearLabel;
@property (strong, nonatomic) UILabel *changeYearLabel;
@property (strong, nonatomic) DKCircleButton *backButton;
@property (strong, nonatomic) DKCircleButton *saveButton;
@property (nonatomic) NSUInteger screenWidth;
@property (nonatomic) NSUInteger screenHeight;
@property (strong, nonatomic) RUFIDataStore *dataStore;
@property (strong, nonatomic) NSDictionary *milesToMetersDictionary;
@property (strong, nonatomic) NSDictionary *distanceValueDictionary;

@end

@implementation RUFISettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [RUFIDataStore sharedDataStore];
    self.view.backgroundColor = [UIColor whiteColor];
    self.radiusArray = @[@"1/8", @"1/4", @"1/2", @"1", @"1.5", @"2", @"2.5", @"3"];
    self.yearsArray = @[@"5", @"4", @"3", @"2", @"1"];
    self.milesToMetersDictionary = @{@"1/8" : @"201", @"1/4": @"402", @"1/2": @"804", @"1": @"1609", @"2": @"3219", @"3": @"4828", @"1.5": @"2414", @"2.5": @"4023"};
    self.distanceValueDictionary = @{@"1/8" : @"1", @"1/4": @"2", @"1/2": @"4", @"1": @"8", @"2": @"16", @"3": @"24", @"1.5": @"12", @"2.5": @"20"};
    
    [self displayRadiusPicker];
    [self addChangeRadiusLabel];
    [self addMilesLabel];
    [self addChangeYearLabel];
    
    [self displayCancelAndSaveButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayRadiusPicker {
    self.picker = [[UIPickerView alloc] init];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.view addSubview:self.picker];
    
    self.picker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.picker.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70].active = YES;
    [self.picker.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.picker.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.picker setBackgroundColor:[UIColor whiteColor]];
    [self.picker setAlpha:0.5];
}

-(void)addChangeRadiusLabel{
    self.changeRadiusLabel = [[UILabel alloc] init];
    [self.view addSubview:self.changeRadiusLabel];
    self.changeRadiusLabel.text = @"Radius:";
    self.changeRadiusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.changeRadiusLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70].active = YES;
    [self.changeRadiusLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:70].active = YES;
}

-(void)addMilesLabel{
    self.milesLabel = [[UILabel alloc] init];
    [self.view addSubview:self.milesLabel];
    self.milesLabel.text = @"mile(s)";
    self.milesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.milesLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:170].active = YES;
    [self.milesLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:130].active = YES;
}

-(void)addChangeYearLabel{
    self.changeYearLabel = [[UILabel alloc] init];
    [self.view addSubview:self.changeYearLabel];
    self.changeYearLabel.text = @"Period of Time:";
    self.changeYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.changeYearLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70].active = YES;
    [self.changeYearLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
    
    [self addYearLabel];
}

-(void)addYearLabel{
    self.milesLabel = [[UILabel alloc] init];
    [self.view addSubview:self.milesLabel];
    self.milesLabel.text = @"year(s)";
    self.milesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.milesLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:170].active = YES;
    [self.milesLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return self.radiusArray.count;
    } else {
        return self.yearsArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == 0){
        return self.radiusArray[row];
    } else {
        return self.yearsArray[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        self.radius = [self.radiusArray objectAtIndex:row];
    } else {
        self.timePeriod = [self.yearsArray objectAtIndex:row];
    }
    
}

-(void)displayCancelAndSaveButton {
    self.screenWidth = self.view.frame.size.width;
    self.screenHeight = self.view.frame.size.height;
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(10, self.screenHeight-60, 50, 50)];
    self.saveButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.screenWidth-60, self.screenHeight-60, 50, 50)];
    NSArray *buttons = @[self.backButton, self.saveButton];
    for (DKCircleButton *button in buttons){
        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        
        if (button == self.backButton){
            
            button.backgroundColor = [UIColor clearColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"back"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;
            
        } else if (button == self.saveButton) {
            
            button.backgroundColor = [UIColor greenColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"save"];
            button.imageEdgeInsets = UIEdgeInsetsMake(3, 4, -7, 3);
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;

        }
        
        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.backButton){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (button == self.saveButton){
        
        self.dataStore.distanceInMeters = self.milesToMetersDictionary[self.radius];
        self.dataStore.yearsAgo = self.timePeriod;
        self.dataStore.distanceInMiles = self.radius;
        self.dataStore.distanceValue = self.distanceValueDictionary[self.radius];
        
        NSLog(@"Result==>  radius: %@,  time period: %@ ", self.radius, self.timePeriod);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - Transition to Size
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    BOOL isPortrait = size.height > size.width;
    BOOL isLandscape = size.width > size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        if(isPortrait){
            
            self.backButton.frame = CGRectMake(10, self.screenHeight-60, 50, 50);
            self.saveButton.frame = CGRectMake(self.screenWidth-60, self.screenHeight-60, 50, 50);
            
        } else if (isLandscape) {
            
            self.backButton.frame = CGRectMake(10, self.screenWidth-60, 50, 50);
            self.saveButton.frame = CGRectMake(self.screenHeight-60, self.screenWidth-60, 50, 50);
            
        }
        [self.view layoutIfNeeded];
    }];
}


@end
