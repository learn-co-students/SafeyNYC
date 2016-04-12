//
//  RUFIIntroViewController.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 4/12/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIIntroViewController.h"
#import <DKCircleButton/DKCircleButton.h>

@interface RUFIIntroViewController ()
@property (strong, nonatomic) IBOutlet DKCircleButton *yesButtonOutlet;
@property (strong, nonatomic) IBOutlet DKCircleButton *noButtonOutlet;

@end

@implementation RUFIIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.yesButtonOutlet.backgroundColor = [UIColor whiteColor];
    self.yesButtonOutlet.borderColor = [UIColor grayColor];
    self.yesButtonOutlet.alpha = 1.0;
    self.yesButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.yesButtonOutlet.animateTap = YES;
    
    self.noButtonOutlet.backgroundColor = [UIColor whiteColor];
    self.noButtonOutlet.borderColor = [UIColor grayColor];
    self.noButtonOutlet.alpha = 1.0;
    self.noButtonOutlet.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.noButtonOutlet.animateTap = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)yesButtonAction:(id)sender {
}
- (IBAction)noButtonAction:(id)sender {
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
