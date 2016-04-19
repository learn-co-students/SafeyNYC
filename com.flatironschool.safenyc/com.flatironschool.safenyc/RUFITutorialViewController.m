//
//  RUFITutorialViewController.m
//  com.flatironschool.safenyc
//
//  Created by Yuchi Zhu on 4/18/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFITutorialViewController.h"
#import <DKCircleButton/DKCircleButton.h>

@interface RUFITutorialViewController ()

@property (strong, nonatomic) UIImageView *emergencyImageView;
@property (strong, nonatomic) DKCircleButton *backButton;
@property (strong, nonatomic) UILabel *addContactTutorialLabel;
@property (strong, nonatomic) UILabel *emergencyTutorialLabel;
@property (strong, nonatomic) NSString *thisButtonWasPressed;
@property (strong, nonatomic) UIImageView *backgroundImage;

@end

@implementation RUFITutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayViewBackground];
    [self displayEmergencyImageView];
    [self displayBackButton];
    [self displayAddContactTutorial];
    [self displayEmergencyTutorial];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)displayViewBackground {
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundImage setImage:[UIImage imageNamed:@"bg15"]];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    self.backgroundImage.alpha = 0.2;
    [self.view addSubview:self.backgroundImage];
    [self.view sendSubviewToBack:self.backgroundImage];
    
}

-(void)displayEmergencyImageView {
    
    self.widthOfTheScreen = self.view.frame.size.width;
    self.heightOfTheScreen = self.view.frame.size.height;
    
    self.emergencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.widthOfTheScreen/2-45, self.widthOfTheScreen-20, self.widthOfTheScreen-20)];
    [self.view addSubview:self.emergencyImageView];
    UIImage *image = [UIImage new];
    image = [UIImage imageNamed:@"emergencyImageView"];
    [self.emergencyImageView setImage:image];
    [self.emergencyImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.emergencyImageView.alpha = 0.3;
    self.emergencyImageView.userInteractionEnabled = YES;
    
}


- (void) displayBackButton {
    
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 30, 50, 50)];
    [self.view addSubview:self.backButton];

    self.backButton.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage new];
    image = [UIImage imageNamed:@"back"];
    [self.backButton setImage:image forState:UIControlStateNormal];
    [self.backButton setContentMode:UIViewContentModeScaleAspectFit];
    self.backButton.alpha = 1;
    self.backButton.animateTap = NO;
    [self.backButton addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    
        }

-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if (button == self.backButton){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



-(void) displayAddContactTutorial {
    self.addContactTutorialLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-150, 80, 300, 20)];
    [self.view addSubview:self.addContactTutorialLabel];
//    self.addContactTutorialLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.addContactTutorialLabel.numberOfLines = 0;
    self.addContactTutorialLabel.adjustsFontSizeToFitWidth = YES;
    self.addContactTutorialLabel.text = @"Tap a contact button to assign a friend";
//    self.addContactTutorialLabel.font = [UIFont systemFontOfSize:22];
}

-(void) displayEmergencyTutorial {
    self.emergencyTutorialLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-150, 80, 300, 1100)];
    [self.view addSubview:self.emergencyTutorialLabel];
    self.emergencyTutorialLabel.text = @"Tap❗️to send a text with your location";
    self.emergencyTutorialLabel.adjustsFontSizeToFitWidth = YES;
//    self.emergencyTutorialLabel.font = [UIFont systemFontOfSize:22];
}

@end



