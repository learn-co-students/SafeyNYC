//
//  PieChartDataViewController.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/31/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "PieChartDataViewController.h"
#import <VBPieChart/VBPieChart.h>

@interface PieChartDataViewController () <VBPieChartDelegate>

@end

@implementation PieChartDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(60, 50, 300, 300)];
    [self.view addSubview:chart];
    chart.delegate = self;
    chart.allowOnlyOneAccentedPiece = YES;
    
    [chart setLabelsPosition:VBLabelsPositionOutChart];
    chart.maxAccentPrecent = 0.2;

    
    // Setup some options:

    [chart setHoleRadiusPrecent:0.8]; /* hole inside of chart */
    
    // Prepare your data
    NSArray *chartValues = @[
                             @{@"name":@"Murder", @"value":@50, @"color":[UIColor redColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Felony Assault", @"value":@70, @"color":[UIColor blueColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Grand Larceny", @"value":@30, @"color":[UIColor orangeColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Grand Larceny Motor Vehicle", @"value":@35, @"color":[UIColor purpleColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Murder", @"value":@10, @"color":[UIColor greenColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Rape", @"value":@10, @"color":[UIColor yellowColor], @"labelColor" : [UIColor blackColor]},
                             @{@"name":@"Robbery", @"value":@10, @"color":[UIColor grayColor], @"labelColor" : [UIColor blackColor]},
                             ];
    
    // Present pie chart with animation
    
//    [chart setChartValues:chartValues];
    
        [chart setChartValues:chartValues animation:YES duration:1.0 options:VBPieChartAnimationFanAll];
}

-(void)pieChart:(VBPieChart *)pieChart didTapPieceAtIndex:(NSInteger)index
{
    NSLog(@"you tapped piece %li", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
