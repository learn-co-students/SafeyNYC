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
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RUFIEmergencyViewController () <CNContactPickerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) DKCircleButton *emergencyButton;
@property (strong, nonatomic) DKCircleButton *person1;
@property (strong, nonatomic) DKCircleButton *person2;
@property (strong, nonatomic) DKCircleButton *person3;
@property (strong, nonatomic) DKCircleButton *person4;
@property (strong, nonatomic) DKCircleButton *person5;
@property (strong, nonatomic) DKCircleButton *person6;
@property (strong, nonatomic) DKCircleButton *backButton;
@property (strong, nonatomic) DKCircleButton *addFriendsButton;
@property (strong, nonatomic) UITextField *holdUntillTextField;


@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self displayButtons];
    [self displayHoldUntillTextField];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-60, 50, 50)];
    self.addFriendsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, self.heightOfTheScreen-60, 50, 50)];
    NSArray *buttons = @[self.emergencyButton, self.person1, self.person2, self.person3, self.person4, self.person5, self.person6, self.backButton, self.addFriendsButton];
    for(DKCircleButton *button in buttons){
        [self.view addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        
        if(button == self.emergencyButton){
        
            button.backgroundColor = [UIColor redColor];
            button.borderColor = [UIColor redColor];
            button.alpha = 0.8;
        
        } else if (button == self.backButton){
            
            button.backgroundColor = [UIColor clearColor];
            //button.borderColor = [UIColor grayColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"back"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;
        
        } else if (button == self.addFriendsButton){
            
            button.backgroundColor = [UIColor redColor];
            //button.borderColor = [UIColor grayColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"addFriend"];
            button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 0, 5);
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;
            
        } else {
            button.backgroundColor = [UIColor lightGrayColor];
            button.borderColor = [UIColor grayColor];
            button.alpha = 0.8;
        }


        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.emergencyButton){
    
        if(![MFMessageComposeViewController canSendText]) {
            NSLog(@"This device can't send texts!");
            return;
        }
        
        MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
        
        composeVC.messageComposeDelegate = self;
        //add recipients
        composeVC.recipients = @[@"4159874354"];
        //BODY MESSAGE
        
        composeVC.body = @"Hey! I am concerned about the neighboorhood I am in. Please check in on me, this is my location";
        
        NSLog(@"%f, %f", self.myCurrnetLatitude, self.myCurrnetLongitude);
        BOOL addedAttachment = [self addLocationAttachmentToComposeViewController:composeVC displayName:@"My Location" location:CLLocationCoordinate2DMake(self.myCurrnetLongitude, self.myCurrnetLatitude)];
        
        if(!addedAttachment) {
            NSLog(@"Seems there was an issue adding the attachment :(");
        }
        
        [self showViewController:composeVC sender:nil];
        
    } else if (button == self.person1){
        
        NSLog(@"Person 1!");
        [self openContacts];
        
    } else if (button == self.person2){
        
        NSLog(@"Person 2!");
        [self openContacts];
        
    } else if (button == self.person3){
        
        NSLog(@"Person 3!");
        [self openContacts];
        
    } else if (button == self.person4){
        
        NSLog(@"Person 4!");
        [self openContacts];
    
    } else if (button == self.person5){
        
        NSLog(@"Person 5!");
        [self openContacts];
   
    } else if (button == self.person6){
        
        NSLog(@"Person 6!");
        [self openContacts];
   
    } else if (button == self.backButton){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else if (button == self.addFriendsButton){
        
        [self openContacts];
        
    }
}

-(void) openContacts {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    [self presentViewController:picker animated:YES completion:nil];
}



-(void) displayHoldUntillTextField {
    self.holdUntillTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-130, 70, 300, 20)];
    [self.view addSubview:self.holdUntillTextField];
    self.holdUntillTextField.text = @"Hold Red Button Untill Safe!";
    self.holdUntillTextField.font = [UIFont systemFontOfSize:22];
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
            self.backButton.frame = CGRectMake(10, self.heightOfTheScreen-60, 50, 50);
            self.addFriendsButton.frame = CGRectMake(self.widthOfTheScreen-60, self.heightOfTheScreen-60, 50, 50);
            
        } else if (isLandscape) {
           
            self.emergencyButton.frame = CGRectMake(self.heightOfTheScreen/2-70, self.widthOfTheScreen/2-70, 140, 140);
            
            self.person3.frame = CGRectMake(self.view.frame.size.height/4*3-50, self.view.frame.size.width/2-25, 50, 50);
            self.person6.frame = CGRectMake(self.view.frame.size.height/4, self.view.frame.size.width/2-25 , 50, 50);
            self.backButton.frame = CGRectMake(10, self.widthOfTheScreen-60, 50, 50);
            self.addFriendsButton.frame = CGRectMake(self.heightOfTheScreen-60, self.widthOfTheScreen-60, 50, 50);

        }
        [self.view layoutIfNeeded];
    }];
}

# pragma mark - Emergency Button
-(BOOL)addLocationAttachmentToComposeViewController:(MFMessageComposeViewController *)composeVC displayName:(NSString *)displayName location:(CLLocationCoordinate2D)location
{
    NSURL *templateURL = [[NSBundle mainBundle] URLForResource:@"location_template" withExtension:@"loc.vcf"];
    
    NSError *error = nil;
    NSMutableString *template = [[NSString stringWithContentsOfURL:templateURL encoding:NSUTF8StringEncoding error:&error] mutableCopy];
    
    if(!template) {
        NSLog(@"Error loading vcard template file: %@", error);
        return NO;
    }
    
    
    NSString *latString = [NSString stringWithFormat:@"%.6f", location.latitude];
    NSString *longString = [NSString stringWithFormat:@"%.6f", location.longitude];
    
    [template replaceOccurrencesOfString:@"$displayname$" withString:displayName options:0 range:NSMakeRange(0, template.length)];
    
    [template replaceOccurrencesOfString:@"$lat$" withString:latString options:0 range:NSMakeRange(0, template.length)];
    
    [template replaceOccurrencesOfString:@"$long$" withString:longString options:0 range:NSMakeRange(0, template.length)];
    
    
    NSData *vcardData = [template dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    
    NSString *filename = [NSString stringWithFormat:@"%@.loc.vcf", displayName];
    
    return [composeVC addAttachmentData:vcardData typeIdentifier:(NSString *)kUTTypeVCard filename:filename];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end



