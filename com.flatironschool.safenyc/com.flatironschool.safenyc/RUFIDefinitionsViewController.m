//
//  RUFIDefinitionsViewController.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 4/11/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIDefinitionsViewController.h"
#import <DKCircleButton/DKCircleButton.h>

@interface RUFIDefinitionsViewController ()
@property (strong, nonatomic) IBOutlet DKCircleButton *backButton;


@end

@implementation RUFIDefinitionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.backgroundColor = [UIColor whiteColor];
    self.backButton.borderColor = [UIColor grayColor];
    self.backButton.alpha = 1.0;
    self.backButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    self.backButton.animateTap = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
