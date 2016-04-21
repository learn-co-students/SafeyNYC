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
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
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
@property (strong, nonatomic) UIImageView *backgroundImage;

@end

@implementation RUFISettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [RUFIDataStore sharedDataStore];
    self.view.backgroundColor = [UIColor whiteColor];

    self.radiusArray = @[[UIImage imageNamed:@"18mile"], [UIImage imageNamed:@"14mile"], [UIImage imageNamed:@"12mile"], [UIImage imageNamed:@"34mile"], [UIImage imageNamed:@"1mile"]];
    self.yearsArray = @[[UIImage imageNamed:@"oneYear"], [UIImage imageNamed:@"twoYears"]];
    self.milesToMetersDictionary = @{@"1/8" : @"201", @"1/4": @"402", @"1/2": @"804", @"1": @"1609", @"3/4": @"1207"};
    self.distanceValueDictionary = @{@"1/8" : @"1", @"1/4": @"2", @"1/2": @"4", @"3/4": @"6", @"1": @"8", };
    
    [self.picker selectRow:2 inComponent:0 animated:YES];
    [self.picker selectRow:0 inComponent:1 animated:YES];
    self.radius = @"1/2";
    self.timePeriod = @"1";
    
    [self displayViewBackground];
    [self displayCancelAndSaveButton];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (void)displayViewBackground {
    //CGFloat width = self.view.frame.size.width;
    //CGRect halfFrame = CGRectMake(20, 185, width+20, 200);
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    //self.backgroundImage = [[UIImageView alloc] initWithFrame:halfFrame];
    // self.backgroundImage.backgroundColor = [UIColor clearColor];
    [self.backgroundImage setImage:[UIImage imageNamed:@"bg25"]];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view addSubview:self.backgroundImage];
    [self.view sendSubviewToBack:self.backgroundImage];
    
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

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    
    if(component == 0){
        return [[UIImageView alloc] initWithImage:self.radiusArray[row]];
    } else {
        return [[UIImageView alloc] initWithImage:self.yearsArray[row]];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if(component == 0){
        
        switch(row)
        
        {
            case 0:
                self.radius = @"1/8";
                break;
                
            case 1:
                self.radius = @"1/4";
                break;
                
            case 2:
                self.radius = @"1/2";
                break;
                
            case 3:
                self.radius = @"3/4";
                break;
                
            case 4:
                self.radius = @"1";
                break;
            }
        
    } else {
        
        switch(row) {
        
    case 0:
        self.timePeriod = @"1";
        break;
        
    case 1:
        self.timePeriod = @"2";
        break;
    }
    }
}

-(void)displayCancelAndSaveButton {
    self.screenWidth = self.view.frame.size.width;
    self.screenHeight = self.view.frame.size.height;
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.screenWidth - 60, 35, 47, 47)];
    self.saveButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.screenWidth - 60, 95, 47, 47)];
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
            
            button.backgroundColor = [UIColor clearColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"ok"];
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
        self.dataStore.settingsChanged = YES;
        
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
            
            self.backgroundImage.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
            self.backButton.frame = CGRectMake(self.screenWidth - 60, 35, 47, 47);
            self.saveButton.frame = CGRectMake(self.screenWidth - 60, 95, 47, 47);
            
        } else if (isLandscape) {
            
            self.backgroundImage.frame = CGRectMake(0, 0, self.screenHeight, self.screenWidth);
            self.backButton.frame = CGRectMake(self.screenHeight - 60, 35, 47, 47);
            self.saveButton.frame = CGRectMake(self.screenHeight - 60, 95, 47, 47);
            
        }
        [self.view layoutIfNeeded];
    }];
}


@end
