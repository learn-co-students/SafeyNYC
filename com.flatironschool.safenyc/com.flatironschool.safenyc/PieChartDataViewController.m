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

@end

@implementation PieChartDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataStore = [[RUFIDataStore alloc] init];
    
    
    self.chart = [[VBPieChart alloc] initWithFrame:CGRectMake(60, 50, 300, 300)];
    [self.pieChartView addSubview:self.chart];
    self.chart.delegate = self;
    self.chart.allowOnlyOneAccentedPiece = YES;
    
    self.chart.maxAccentPrecent = 0.2;
    
    
    
    [self.chart setHoleRadiusPrecent:0.6];
    
    
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.dataStore getCrimeDataWithCompletion:^(BOOL finished) {
        if (finished) {
            
            self.chartValues = @[
                                 @{@"name":@"MURDER & NON-NEGL. MANSLAUGHTER", @"value":[self convertValuetoNumber:self.dataStore.murderCount], @"color":[UIColor redColor], @"image" : @"murderPie"},
                                 @{@"name":@"Felony Assault", @"value":[self convertValuetoNumber:self.dataStore.felonyAssaultCount], @"color":[UIColor orangeColor], @"image" : @"felonyPie"},
                                 @{@"name":@"Grand Larceny", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyCount], @"color":[UIColor blueColor], @"image" : @"grandLarcenyPie"},
                                 @{@"name":@"Grand Larceny Motor Vehicle", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyMVCount], @"color":[UIColor purpleColor], @"image" : @"grandLarcenyMVPie"},
                                 @{@"name":@"Burglary", @"value":[self convertValuetoNumber:self.dataStore.burglaryCount], @"color":[UIColor greenColor], @"image" : @"burglaryPie"},
                                 @{@"name":@"Rape", @"value":[self convertValuetoNumber:self.dataStore.rapeCount], @"color":[UIColor yellowColor], @"image" : @"rapePie"},
                                 @{@"name":@"Robbery", @"value":[self convertValuetoNumber:self.dataStore.robberyCount], @"color":[UIColor brownColor], @"image" : @"robberyPie"},
                                 ];
            
            
            NSLog(@"GL; %lu", self.dataStore.grandLarcenyCount);
            
            [self.chart setChartValues:self.chartValues animation:YES duration:1.0 options:VBPieChartAnimationFanAll];
            
            
        }
    }];
    
    
    
    
}

-(void)pieChart:(VBPieChart *)pieChart didTapPieceAtIndex:(NSInteger)index
{
    
    self.crimeLabel.text = [NSString stringWithFormat:@"%@: %@",[self.chartValues objectAtIndex:index][@"name"], [self.chartValues objectAtIndex:index][@"value"]];
    
    UIImage *pieImageView = [UIImage imageNamed:[self.chartValues objectAtIndex:index][@"image"]];
    [self.pieImage setImage:pieImageView];
    
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

@end
