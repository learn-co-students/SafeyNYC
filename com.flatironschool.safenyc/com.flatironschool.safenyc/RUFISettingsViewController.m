//
//  RUFISettingsViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/3/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFISettingsViewController.h"

@interface RUFISettingsViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveItem;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSArray *radiusArray;
@property (strong, nonatomic) NSArray *yearsArray;
@property (strong, nonatomic) UILabel *changeRadiusLabel;
@property (strong, nonatomic) UILabel *milesLabel;
@property (strong, nonatomic) UILabel *changeYearLabel;

@end

@implementation RUFISettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.radiusArray = @[@"0.5", @"0.6", @"0.7", @"0.8", @"0.9 ", @"1.0", @"2.0 ", @"3.0 ", @"4.0", @"5.0"];
    self.yearsArray = @[@"All data", @"2016", @"2015", @"2014", @"2013", @"2012", @"2011", @"2010"];
    
    [self displayRadiusPicker];
    [self addChangeRadiusLabel];
    [self addMilesLabel];
    
    //[self displayYearPicker];
    [self addChangeYearLabel];
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
    self.milesLabel.text = @"miles";
    self.milesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.milesLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:170].active = YES;
    [self.milesLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:130].active = YES;
}

-(void)addChangeYearLabel{
    self.changeYearLabel = [[UILabel alloc] init];
    [self.view addSubview:self.changeYearLabel];
    self.changeYearLabel.text = @"Year:";
    self.changeYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.changeYearLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70].active = YES;
    [self.changeYearLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-70].active = YES;
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

- (IBAction)cancelItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveItem:(id)sender {
     NSLog(@"Result==>  radius: %@,  time period: %@ ", self.radius, self.timePeriod);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
