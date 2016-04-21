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
    
    self.dataStore = [RUFIDataStore sharedDataStore];
    
    self.agreementAccepted = [NSUserDefaults standardUserDefaults];
    

    
    
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
    

    self.dataStore.agreementBool = YES;
    
    NSLog(@"AGREEMENT BOOL IN INTRO %d", self.dataStore.agreementBool);
    
    
    [self.agreementAccepted setBool:YES forKey:@"hasLoggedIn"];
    
    [self.agreementAccepted synchronize];
    
    [self dismissViewControllerAnimated:nil completion:nil];
    
  

    
}
- (IBAction)noButtonAction:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Uh-Oh"
                                                                   message: @"You must accept these terms to use the Safey NYC."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


@end
