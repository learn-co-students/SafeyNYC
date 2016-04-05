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
@property (strong, nonatomic) UIPickerView *radiusPicker;
@property (strong, nonatomic) NSArray *radiusArray;
@property (strong, nonatomic) UILabel *changeRadiusLabel;
@property (strong, nonatomic) UILabel *milesLabel;

@end

@implementation RUFISettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.radiusArray = @[@"0.5 ", @"0.6 ", @"0.7 ", @"0.8 ", @"0.9 ", @"1.0 ", @"2.0 ", @"3.0 ", @"4.0 ", @"5.0 "];
    [self displayRadiusPicker];
    [self addChangeRadiusLabel];
    [self addMilesLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayRadiusPicker {
    self.radiusPicker = [[UIPickerView alloc] init];
    self.radiusPicker.delegate = self;
    self.radiusPicker.dataSource = self;
    [self.view addSubview:self.radiusPicker];
    
    self.radiusPicker.translatesAutoresizingMaskIntoConstraints = NO;
    [self.radiusPicker.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50].active = YES;
    [self.radiusPicker.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.radiusPicker.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    [self.radiusPicker setBackgroundColor:[UIColor whiteColor]];
}

-(void)addChangeRadiusLabel{
    self.changeRadiusLabel = [[UILabel alloc] init];
    [self.view addSubview:self.changeRadiusLabel];
    self.changeRadiusLabel.text = @"Change radius:";
    self.changeRadiusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.changeRadiusLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150].active = YES;
    [self.changeRadiusLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20].active = YES;
}

-(void)addMilesLabel{
    self.milesLabel = [[UILabel alloc] init];
    [self.view addSubview:self.milesLabel];
    self.milesLabel.text = @"miles";
    self.milesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.milesLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:150].active = YES;
    [self.milesLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-120].active = YES;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.radiusArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.radiusArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.radius = [self.radiusArray objectAtIndex:row];
}

- (IBAction)cancelItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveItem:(id)sender {
     NSLog(@"Result: %@", self.radius);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
