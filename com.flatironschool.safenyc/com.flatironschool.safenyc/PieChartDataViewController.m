//
//  PieChartDataViewController.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/31/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "PieChartDataViewController.h"
#import <VBPieChart/VBPieChart.h>
#import "RUFIDataStore.h"

@interface PieChartDataViewController () <VBPieChartDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *pieImage;
@property (strong, nonatomic) VBPieChart *chart;
@property (strong, nonatomic) IBOutlet UILabel *crimeLabel;
@property (strong,nonatomic) NSArray *chartValues;
@property (strong, nonatomic) RUFIDataStore *dataStore;
@property (strong, nonatomic) IBOutlet UIView *pieChartView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;

@end

@implementation PieChartDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.dataStore = [RUFIDataStore sharedDataStore];    
    //self.chart = [[VBPieChart alloc] initWithFrame:CGRectMake(60, 50, 300, 300)];

    self.dataStore = [[RUFIDataStore alloc] init];
    self.chart = [[VBPieChart alloc] initWithFrame:CGRectMake(50, 20, 300, 300)];
    [self.pieChartView addSubview:self.chart];
    self.chart.delegate = self;
    self.chart.allowOnlyOneAccentedPiece = YES;
    self.chart.maxAccentPrecent = 0.1;
    [self.chart setHoleRadiusPrecent:0.6];
    
}




-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: YES];
    
    [self.dataStore getCrimeDataWithCompletion:^(BOOL finished) {
        
        if (finished) {
            
            NSLog(@"Getting to Pie Chart");
            
            self.chartValues = @[
                                 @{@"name":@"MURDER & MANSLAUGHTER", @"value":[self convertValuetoNumber:self.dataStore.murderCount], @"color":@"EC1D24", @"image" : @"murderPie"},
                                 @{@"name":@"FELONY ASSAULT", @"value":[self convertValuetoNumber:self.dataStore.felonyAssaultCount], @"color":@"F6931D", @"image" : @"felonyPie"},
                                 @{@"name":@"GRAND LARCENY", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyCount], @"color":@"2E3092", @"image" : @"grandLarcenyPie"},
                                 @{@"name":@"GRAND LARCENY OF MOTOR VEHICLE", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyMVCount], @"color":@"772477", @"image" : @"grandLarcenyMVPie"},
                                 @{@"name":@"BURGLARY", @"value":[self convertValuetoNumber:self.dataStore.burglaryCount], @"color":@"006738", @"image" : @"burglaryPie"},
                                 @{@"name":@"RAPE", @"value":[self convertValuetoNumber:self.dataStore.rapeCount], @"color":@"F8EC31", @"image" : @"rapePie"},
                                 @{@"name":@"ROBBERY", @"value":[self convertValuetoNumber:self.dataStore.robberyCount], @"color":@"A87B4F", @"image" : @"robberyPie"},];
            
            [self.chart setChartValues:self.chartValues animation:YES duration:1.0 options:VBPieChartAnimationFanAll];
            
            self.crimeLabel.text = [NSString stringWithFormat:@"There has been %lu felonies commited in the quarter mile radius of where you are standing in the past two years.", self.dataStore.crimeDataArray.count];

        }
   
    }];
    
}

-(void)pieChart:(VBPieChart *)pieChart didTapPieceAtIndex:(NSInteger)index {
    
//    self.crimeLabel.text = [NSString stringWithFormat:@"%@: %@",[self.chartValues objectAtIndex:index][@"name"], [self.chartValues objectAtIndex:index][@"value"]];
    
    UIImage *pieImageView = [UIImage imageNamed:[self.chartValues objectAtIndex:index][@"image"]];
    
    
    
    [self.pieImage setImage:pieImageView];
    
}

-(NSNumber *)convertValuetoNumber:(NSUInteger) crimeCount {
    
    NSNumber *countNSNumber = @(crimeCount);;
    
    return  countNSNumber;
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(NSNumber *)convertValuetoNumber:(NSUInteger) crimeCount {
    
    NSNumber *countNSNumber = @(crimeCount);;
    return  countNSNumber;
    
}


- (IBAction)cancelItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
