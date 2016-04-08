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

@property (strong, nonatomic) UIImageView *emergencyImageView;
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
@property (strong, nonatomic) CNMutableContact *contact1;
@property (strong, nonatomic) CNMutableContact *contact2;
@property (strong, nonatomic) CNMutableContact *contact3;
@property (strong, nonatomic) CNMutableContact *contact4;
@property (strong, nonatomic) CNMutableContact *contact5;
@property (strong, nonatomic) CNMutableContact *contact6;
@property (strong, nonatomic) CNContactStore *contactStore;
@property (strong, nonatomic) NSString *thisButtonWasPressed;
@property (strong, nonatomic) NSArray *allContacts;
@property (nonatomic) BOOL isContactePicked;
@property (strong, nonatomic) MFMessageComposeViewController *composeVC;



@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self displayEmergencyImageView];
    [self displayButtons];
    [self displayHoldUntillTextField];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
    self.emergencyImageView.userInteractionEnabled = YES;
    
}


- (void) displayButtons {
    
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140)];
    self.person1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(51, 21, 87, 87)];
    self.person2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-95, self.widthOfTheScreen-21, 87, 87)];
    self.person3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-100, self.heightOfTheScreen/2-25, 87, 87)];
    self.person4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-155, self.heightOfTheScreen/2+75, 87, 87)];
    self.person5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(100, self.heightOfTheScreen/2+75, 87, 87)];
    self.person6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(50, self.heightOfTheScreen/2-25, 87, 87)];
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 30, 87, 87)];
    self.addFriendsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 90, 50, 50)];
    NSArray *buttons = @[self.emergencyButton, self.person1, self.person2, self.person3, self.person4, self.person5, self.person6, self.backButton, self.addFriendsButton];
    for(DKCircleButton *button in buttons){
        if(button == self.backButton || button == self.addFriendsButton){
            [self.view addSubview:button];
        } else if (button == self.person1 || button == self.emergencyButton){
            [self.emergencyImageView addSubview:button];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        
        if(button == self.emergencyButton){
        
            button.backgroundColor = [UIColor redColor];
            button.borderColor = [UIColor redColor];
            button.alpha = 1;
        
        } else if (button == self.backButton){
            
            button.backgroundColor = [UIColor clearColor];
            //button.borderColor = [UIColor grayColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"back"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;
        
        } else if (button == self.addFriendsButton || button == self.person1){
            
            button.backgroundColor = [UIColor clearColor];
            //button.borderColor = [UIColor grayColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"addFriend"];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFill];
            button.alpha = 1;
            
        } else {
            button.backgroundColor = [UIColor lightGrayColor];
            button.borderColor = [UIColor grayColor];
            button.alpha = 0.8;
        }


//        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    //NSUInteger index = 0;
    
    if(button == self.emergencyButton){
    
        [self emergencyMessage];
        
    } else if (button == self.person1){
        
        NSLog(@"Person 1!");
        [self openContacts];
//        if(![self.contact1 isEqual:@""]){
//            [self updateButtonWithPictureOf:button];
//        }
        //[self updateButtonWithPictureOf:self.person1];
        
    } else if (button == self.person2){
        
        NSLog(@"Person 2!");
        //[self openContacts];
        
    } else if (button == self.person3){
        
        NSLog(@"Person 3!");
        //[self openContacts];
        
    } else if (button == self.person4){
        
        NSLog(@"Person 4!");
        //[self openContacts];
    
    } else if (button == self.person5){
        
        NSLog(@"Person 5!");
        //[self openContacts];
   
    } else if (button == self.person6){
        
        NSLog(@"Person 6!");
        //[self openContacts];
   
    } else if (button == self.backButton){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else if (button == self.addFriendsButton){
        
        [self openContacts];
    }
}


-(void) emergencyMessage{
    
    if(![MFMessageComposeViewController canSendText]) {
        NSLog(@"This device can't send texts!");
        return;
    }
    
    self.composeVC = [[MFMessageComposeViewController alloc] init];
    
    self.composeVC.messageComposeDelegate = self;
    //add recipients
    self.composeVC.recipients = @[@"4159874354"];
    //BODY MESSAGE
    
    self.composeVC.body = @"Hey! I am concerned about the neighboorhood I am in. Please check in on me, this is my location";
    
    NSLog(@"%f, %f", self.myCurrnetLatitude, self.myCurrnetLongitude);
    BOOL addedAttachment = [self addLocationAttachmentToComposeViewController:self.composeVC displayName:@"My Location" location:CLLocationCoordinate2DMake(self.myCurrnetLongitude, self.myCurrnetLatitude)];
    
    if(!addedAttachment) {
        NSLog(@"Seems there was an issue adding the attachment :(");
    }
    
    [self showViewController:self.composeVC sender:nil];

}

-(void) openContacts {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    [self presentViewController:picker animated:YES completion:nil];
    picker.displayedPropertyKeys = @[@[CNContactImageDataKey], @[CNContactGivenNameKey], @[CNContactFamilyNameKey], @[CNLabelPhoneNumberMain]];
}

- (void) contactPickerDidCancel: (CNContactPickerViewController *) picker {
    
    NSLog(@"contactPickerDidCancel");
}

- (void) contactPicker: (CNContactPickerViewController *) picker
      didSelectContact: (CNContact *) contact {
   
    NSLog(@"contactpicked: %@", contact);
    self.contact1 = [contact mutableCopy];
    self.isContactePicked = YES;
    NSLog(@"copy set to property: %@", self.contact1);
    [self updateButtonWithPicture];
    
}

-(void)updateButtonWithPicture {
    
    UIImage *image = [UIImage imageWithData:self.contact1.thumbnailImageData];
    NSLog(@"image: %@", image);
    [self.person1 setImage:image forState:UIControlStateNormal];
    
}

/*
-(void) contactsFromAddressBook {
    self.contactStore = [[CNContactStore alloc] init];
    [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = self.contactStore.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *contacts = [self.contactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *phone;
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                UIImage *profileImage;
                NSMutableArray *contactNumbersArray;
                for (CNContact *contact in contacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    UIImage *image = [UIImage imageWithData:contact.imageData];
                    if (image != nil) {
                        profileImage = image;
                    }else{
                        profileImage = [UIImage imageNamed:@"person-icon.png"];
                    }
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        phone = [label.value stringValue];
                        if ([phone length] > 0) {
                            [contactNumbersArray addObject:phone];
                        }
                    }
                    NSDictionary* personDict = [[NSDictionary alloc] initWithObjectsAndKeys: fullName,@"fullName",profileImage,@"userImage",phone,@"PhoneNumbers", nil];
                    [self.contactsArray addObject:personDict];
                }
                dispatch_async(dispatch_get_main_queue(), ^
                               {
                                   NSLog(@"%@",contacts);
                                   //[self.tableViewRef reloadData];
                               });
            }
        }
    }];
}*/



-(void) displayHoldUntillTextField {
    self.holdUntillTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-150, 80, 300, 20)];
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
            
            self.emergencyImageView.frame = CGRectMake(10, self.widthOfTheScreen/2-45, self.widthOfTheScreen-20, self.widthOfTheScreen-20);
            self.emergencyButton.frame = CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140);
            
            self.person1.frame = CGRectMake(52, 21, 85, 85);
            self.person2.frame = CGRectMake(self.widthOfTheScreen-150, self.heightOfTheScreen/2-120, 50, 50);
            self.person3.frame = CGRectMake(self.widthOfTheScreen-100, self.heightOfTheScreen/2-25, 50, 50);
            
            self.person6.frame = CGRectMake(50,self.heightOfTheScreen/2-25, 50, 50);
            self.backButton.frame = CGRectMake(self.widthOfTheScreen-60, 30, 50, 50);
            self.addFriendsButton.frame = CGRectMake(self.widthOfTheScreen-60, 90, 50, 50);
            self.holdUntillTextField.frame = CGRectMake(self.widthOfTheScreen/2-150, 80, 300, 20);
            
        } else if (isLandscape) {
           
            self.emergencyButton.frame = CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140);
            self.emergencyImageView.frame = CGRectMake(self.widthOfTheScreen/2-31, 0, self.widthOfTheScreen-20, self.widthOfTheScreen-20);
            
            self.person3.frame = CGRectMake(self.view.frame.size.height/4*3-50, self.view.frame.size.width/2-25, 50, 50);
            self.person6.frame = CGRectMake(self.view.frame.size.height/4, self.view.frame.size.width/2-25 , 50, 50);
            self.backButton.frame = CGRectMake(self.heightOfTheScreen-60, 30, 50, 50);
            self.addFriendsButton.frame = CGRectMake(self.heightOfTheScreen-60, 90, 50, 50);
            self.holdUntillTextField.frame = CGRectMake(10, self.widthOfTheScreen-30, 300, 20);

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



