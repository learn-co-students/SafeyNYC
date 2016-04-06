//
//  RUFIEmergencyViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/3/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIEmergencyViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import <DKCircleButton/DKCircleButton.h>

@interface RUFIEmergencyViewController () <CNContactPickerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItem;
@property (strong, nonatomic) DKCircleButton *emergencyButton;
@property (strong, nonatomic) DKCircleButton *person1;
@property (strong, nonatomic) DKCircleButton *person2;
@property (strong, nonatomic) DKCircleButton *person3;
@property (strong, nonatomic) DKCircleButton *person4;
@property (strong, nonatomic) DKCircleButton *person5;
@property (strong, nonatomic) DKCircleButton *person6;
@property (nonatomic)  NSUInteger heightOfTheScreen;
@property (nonatomic)  NSUInteger widthOfTheScreen;


@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self displayButtons];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addItem:(id)sender {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void) displayButtons {
    self.widthOfTheScreen = self.view.frame.size.width;
    self.heightOfTheScreen = self.view.frame.size.height;
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-70, self.heightOfTheScreen/2-70, 140, 140)];
    self.person1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(100, self.heightOfTheScreen/2-120, 50, 50)];
    self.person2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-155, self.heightOfTheScreen/2-120, 50, 50)];
    self.person3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-100, self.heightOfTheScreen/2-25, 50, 50)];
    self.person4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-155, self.heightOfTheScreen/2+75, 50, 50)];
    self.person5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(100, self.heightOfTheScreen/2+75, 50, 50)];
    self.person6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(50, self.heightOfTheScreen/2-25, 50, 50)];
    NSArray *buttons = @[self.emergencyButton, self.person1, self.person2, self.person3, self.person4, self.person5, self.person6];
    for(DKCircleButton *button in buttons){
        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        if(button == self.emergencyButton){
            button.backgroundColor = [UIColor redColor];
            button.borderColor = [UIColor redColor];
        } else {
            button.backgroundColor = [UIColor lightGrayColor];
            button.borderColor = [UIColor grayColor];
        }
        button.alpha = 0.8;
        
        
                //button.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        //[button setImage:image forState:UIControlStateNormal];
        //[button setContentMode:UIViewContentModeScaleAspectFit];

        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.emergencyButton){
    
        NSLog(@"Emergency!");
        
    } else if (button == self.person1){
        
        NSLog(@"Person 1!");
        
    } else if (button == self.person2){
        
        NSLog(@"Person 2!");
        
    } else if (button == self.person3){
        
        NSLog(@"Person 3!");
        
    } else if (button == self.person4){
        
        NSLog(@"Person 4!");
    
    } else if (button == self.person5){
        
        NSLog(@"Person 5!");
   
    } else if (button == self.person6){
        
        NSLog(@"Person 6!");
    }
}

#pragma mark - Transition to Size
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    BOOL isPortrait = size.height > size.width;
    BOOL isLandscape = size.width > size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        if(isPortrait){
            
            self.emergencyButton.frame = CGRectMake(self.widthOfTheScreen/2-70, self.heightOfTheScreen/2-70, 140, 140);
            
            self.person1.frame = CGRectMake(100, self.heightOfTheScreen/2-120, 50, 50);
            self.person2.frame = CGRectMake(self.widthOfTheScreen-150, self.heightOfTheScreen/2-120, 50, 50);
            self.person3.frame = CGRectMake(self.widthOfTheScreen-100, self.heightOfTheScreen/2-25, 50, 50);
            
            self.person6.frame = CGRectMake(50,self.heightOfTheScreen/2-25, 50, 50);
            
        } else if (isLandscape) {
           
            self.emergencyButton.frame = CGRectMake(self.heightOfTheScreen/2-70, self.widthOfTheScreen/2-70, 140, 140);
            
            //self.person1.frame = CGRectMake(100, self.view.frame.size.height/2-120, 50, 50);
            //self.person2.frame = CGRectMake(self.view.frame.width/3, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
            self.person3.frame = CGRectMake(self.view.frame.size.height/4*3-50, self.view.frame.size.width/2-25, 50, 50);
            self.person6.frame = CGRectMake(self.view.frame.size.height/4, self.view.frame.size.width/2-25 , 50, 50);
        }
        [self.view layoutIfNeeded];
    }];
}


@end



