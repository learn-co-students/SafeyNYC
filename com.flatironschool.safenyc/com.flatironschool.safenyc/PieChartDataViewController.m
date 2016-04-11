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
#import <DKCircleButton/DKCircleButton.h>
#import <GraphKit/GraphKit.h>

@interface PieChartDataViewController () <VBPieChartDelegate, GKBarGraphDataSource>

@property (strong, nonatomic) IBOutlet UIView *chartSuper;
@property (strong,nonatomic) NSArray *chartValues;
@property (strong, nonatomic) RUFIDataStore *dataStore;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet DKCircleButton *backButton;
@property (strong, nonatomic) IBOutlet DKCircleButton *infoButton;
@property (strong, nonatomic) VBPieChart *chart;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraph;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) IBOutlet UIImageView *crimeSign;
@property (strong, nonatomic) IBOutlet UILabel *inThePastLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalNumberLabel;

;

@end

@implementation PieChartDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.dataStore = [RUFIDataStore sharedDataStore];
    self.chart = [[VBPieChart alloc] initWithFrame:CGRectZero];
    [self.chartSuper addSubview:self.chart];
    
    self.chart.delegate = self;
    self.chart.allowOnlyOneAccentedPiece = YES;
    self.chart.maxAccentPrecent = 0.1;
    [self.chart setHoleRadiusPrecent:0.1];
    self.backButton.backgroundColor = [UIColor whiteColor];
    self.backButton.borderColor = [UIColor grayColor];
    self.backButton.alpha = 1.0;
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.backButton.animateTap = YES;
    self.infoButton.backgroundColor = [UIColor whiteColor];
    self.infoButton.borderColor = [UIColor grayColor];
    self.infoButton.alpha = 1.0;
    self.infoButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.infoButton.animateTap = YES;
    self.labels = @[@"M", @"FA", @"GL", @"B", @"R", @"RB", @"GMV"];

    self.barGraph.animationDuration = 2.0;
    self.barGraph.barColor = [UIColor whiteColor];

    
    
    self.colors = @[[UIColor colorWithRed:0.89 green:0.251 blue:0.271 alpha:1],
                    [UIColor colorWithRed:0.984 green:0.729 blue:0.384 alpha:1],
                    [UIColor colorWithRed:0.353 green:0.38 blue:0.659 alpha:1],
                    [UIColor colorWithRed:0.451 green:0.714 blue:0.29 alpha:1],
                    [UIColor colorWithRed:1 green:0.945 blue:0 alpha:1],
                    [UIColor colorWithRed:0.682 green:0.871 blue:0.89 alpha:1],
                    [UIColor colorWithRed:0.533 green:0.38 blue:0.663 alpha:1]];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    NSLog(@"viewDidDISAPPEAR CALLEDDDDD\n\n\n");
    [self.chart removeFromSuperview];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: YES];
    self.inThePastLabel.textColor = [UIColor darkGrayColor];
    self.inThePastLabel.shadowColor = [UIColor whiteColor];
    self.inThePastLabel.shadowOffset = CGSizeMake(0, -1);
    self.inThePastLabel.text = [NSString stringWithFormat:@"In the past %@ year(s) there has been %lu felonies commited in the %@ mile radius from where you are standing.", self.dataStore.yearsAgo, (unsigned long)self.dataStore.crimeDataArray.count, self.dataStore.distanceInMiles];
    
    
    CGFloat chartSuperHeight = self.chartSuper.frame.size.height;
    CGFloat startingPoint = (self.chartSuper.frame.size.width - self.chartSuper.frame.size.height)/2;
    
    self.chart.frame = CGRectMake(startingPoint, 0, chartSuperHeight, chartSuperHeight);
    
    self.barGraph.barHeight = self.barGraph.frame.size.height - 20;
    
    CGFloat barSize = self.barGraph.frame.size.width/13;
    
    self.barGraph.barWidth = barSize;
    
    self.barGraph.marginBar = barSize;
    
    self.chartValues = @[
                         @{@"name":@"MURDER & MANSLAUGHTER", @"value":[self convertValuetoNumber:self.dataStore.murderCount], @"color":@"E34045", @"image" : @"murderSign"},
                         @{@"name":@"FELONY ASSAULT", @"value":[self convertValuetoNumber:self.dataStore.felonyAssaultCount], @"color":@"FBBA62", @"image" : @"felonySign"},
                         @{@"name":@"GRAND LARCENY", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyCount], @"color":@"5A61A8", @"image" : @"grandLarcenySign"},
                         @{@"name":@"BURGLARY", @"value":[self convertValuetoNumber:self.dataStore.burglaryCount], @"color":@"73B64A", @"image" : @"burglarySign"},
                         @{@"name":@"RAPE", @"value":[self convertValuetoNumber:self.dataStore.rapeCount], @"color":@"FFF100", @"image" : @"rapeSign"},
                         @{@"name":@"ROBBERY", @"value":[self convertValuetoNumber:self.dataStore.robberyCount], @"color":@"AEDEE3", @"image" : @"robberySign"},
                         @{@"name":@"GRAND LARCENY OF MOTOR VEHICLE", @"value":[self convertValuetoNumber:self.dataStore.grandLarcenyMVCount], @"color":@"8861A9", @"image" : @"glmvSign"}];
    
    [self.chart setChartValues:self.chartValues animation:YES duration:1.0 options:VBPieChartAnimationFanAll];
    
    
    
    
    self.barGraph.dataSource = self;
    
    [self.barGraph draw];
    
    //        }
    //
    //    }];
    
}

-(void)pieChart:(VBPieChart *)pieChart didTapPieceAtIndex:(NSInteger)index {
    
    //    self.crimeLabel.text = [NSString stringWithFormat:@"%@: %@",[self.chartValues objectAtIndex:index][@"name"], [self.chartValues objectAtIndex:index][@"value"]];
    
    CGFloat percentage = ([[self.chartValues objectAtIndex:index][@"value"] doubleValue] / self.dataStore.crimeDataArray.count) * 100;
    
    UIImage *crimeImage = [UIImage imageNamed:[self.chartValues objectAtIndex:index][@"image"]];
    [self.crimeSign setImage:crimeImage];
    self.percentLabel.text = [NSString stringWithFormat:@"Percentage of incidents: %.1f%%", percentage];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"Total number of incidents: %@", [self.chartValues objectAtIndex:index][@"value"]];
    
    self.percentLabel.textColor = [UIColor darkGrayColor];
    self.percentLabel.shadowColor = [UIColor whiteColor];
    self.percentLabel.shadowOffset = CGSizeMake(0, -1);
    self.totalNumberLabel.textColor = [UIColor darkGrayColor];
    self.totalNumberLabel.shadowColor = [UIColor whiteColor];
    self.totalNumberLabel.shadowOffset = CGSizeMake(0, -1);
    
    
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



- (IBAction)backButtonAction:(id)sender {
    
    [self.chart removeFromSuperview];
    self.chart = nil;
    [self.barGraph removeFromSuperview];
    self.barGraph = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)infoButtonAction:(id)sender {
}


#pragma mark - GKBarGraphDataSource

- (NSInteger)numberOfBars {
    
    NSLog(@"NUMBER OF BARS %li", (unsigned long)self.chartValues.count);
    return self.chartValues.count;
    
    
}

- (NSNumber *)valueForBarAtIndex:(NSInteger)index {
    
    CGFloat percentage = ([[self.chartValues objectAtIndex:index][@"value"] doubleValue] / self.dataStore.crimeDataArray.count) * 100;
    NSLog(@"VALUE %li : %.2f", (long)index, percentage);
    
    NSNumber *percentNumber = @(percentage);
    
    NSLog(@"VALUE %li : %@", (long)index, percentNumber);
    
    return percentNumber;
    
    //    NSLog(@"VALUE %li : %@", (long)index, [self.chartValues objectAtIndex:index][@"value"]);
    //    return [self.chartValues objectAtIndex:index][@"value"];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index {
    
    return [self.colors objectAtIndex:index];
}

//- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
//    return [UIColor redColor];
//}

- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index {
    CGFloat percentage = [[self valueForBarAtIndex:index] doubleValue];
    percentage = (percentage / 100);
    return (self.barGraph.animationDuration * percentage);
}

- (NSString *)titleForBarAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index {
    
    NSArray *clearColor = @[[UIColor clearColor], [UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]];
    
    return [clearColor objectAtIndex:index];
    
}






@end
