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
@property (strong, nonatomic) DKCircleButton *currentPerson;
@property (strong, nonatomic) UITextField *holdUntillTextField;
//@property (strong, nonatomic) CNMutableContact *contact1;
//@property (strong, nonatomic) CNMutableContact *contact2;
//@property (strong, nonatomic) CNMutableContact *contact3;
//@property (strong, nonatomic) CNMutableContact *contact4;
//@property (strong, nonatomic) CNMutableContact *contact5;
//@property (strong, nonatomic) CNMutableContact *contact6;
//@property (strong, nonatomic) CNContactStore *contactStore;
@property (strong, nonatomic) NSString *thisButtonWasPressed;
@property (nonatomic) BOOL isContactePicked;
@property (strong, nonatomic) MFMessageComposeViewController *composeVC;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (nonatomic) RUFIContactStore *localContactStore;
@property (strong, nonatomic) NSArray *localContacts;

@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self displayViewBackground];
    [self displayEmergencyImageView];
    [self displayButtons];
    [self displayHoldUntillTextField];
    
//    self.localContactStore = [RUFIContactStore sharedContactStore];
//    
//    [self.localContactStore fetchData];
//    
//    self.localContacts = self.localContactStore.contacts;
//    
//    NSLog(@"\n %@ ", self.localContacts);

}

-(void)viewDidAppear:(BOOL)animated {
    
//    [self.localContactStore fetchData];
//    
//    self.localContacts = self.localContactStore.contacts;
//    
//    NSLog(@"\n ALL CONTACTS: %@ \n", self.localContacts);
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)displayViewBackground {
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundImage setImage:[UIImage imageNamed:@"bg25"]];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
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
    self.emergencyImageView.userInteractionEnabled = YES;
    
}


- (void) displayButtons {
    
    self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140)];
    self.person1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(51, 20, 87, 87)];
    self.person2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-157, 19, 87, 87)];
    self.person3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-106, self.widthOfTheScreen/2-52, 87, 87)];
    self.person4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-51-107, self.widthOfTheScreen-127, 87, 87)];
    self.person5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(59, self.widthOfTheScreen-127, 87, 87)];
    self.person6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(0, self.widthOfTheScreen/2-52, 87, 87)];
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 30, 50, 50)];
    self.addFriendsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 90, 50, 50)];
    NSArray *buttons = @[self.emergencyButton, self.person1, self.person2, self.person3, self.person4, self.person5, self.person6, self.backButton, self.addFriendsButton];
    for(DKCircleButton *button in buttons){
        if(button == self.backButton || button == self.addFriendsButton){
            [self.view addSubview:button];
        } else {
            [self.emergencyImageView addSubview:button];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        
        if(button == self.emergencyButton){
        
            button.backgroundColor = [UIColor redColor];
            button.borderColor = [UIColor whiteColor];
            button.alpha = 1;
        
        } else if (button == self.backButton){
            
            button.backgroundColor = [UIColor clearColor];
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"back"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            button.alpha = 1;
        
        } else {
            
            if(button == self.addFriendsButton){
                button.backgroundColor = [UIColor grayColor];
            } else {
                button.backgroundColor = [UIColor clearColor];
            }
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"addFriend"];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [button setBackgroundImage:image forState:UIControlStateNormal];
//            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFill];
            button.alpha = 1;
            
        }
        
        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.emergencyButton){
    
        [self emergencyMessage];
        
    } else if (button == self.person1){
        
        NSLog(@"Person 1!");
        [self openContacts];
        self.currentPerson = _person1;
//        [self openContacts];
//        if(![self.contact1 isEqual:@""]){
//            [self updateButtonWithPictureOf:button];
//        }
        //[self updateButtonWithPictureOf:self.person1];
        
    } else if (button == self.person2){
        
        NSLog(@"Person 2!");
        [self openContacts];
        self.currentPerson = _person2;
        
    } else if (button == self.person3){
        
        NSLog(@"Person 3!");
        [self openContacts];
        self.currentPerson = _person3;
        
    } else if (button == self.person4){
        
        NSLog(@"Person 4!");
        [self openContacts];
        self.currentPerson = _person4;
    
    } else if (button == self.person5){
        
        NSLog(@"Person 5!");
        [self openContacts];
        self.currentPerson = _person5;
   
    } else if (button == self.person6){
        
        NSLog(@"Person 6!");
        [self openContacts];
        self.currentPerson = _person6;
   
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
    //    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    //    picker.delegate = self;
    //    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    //    [self presentViewController:picker animated:YES completion:nil];
    //    picker.displayedPropertyKeys = @[@[CNContactImageDataKey], @[CNContactGivenNameKey], @[CNContactFamilyNameKey], @[CNLabelPhoneNumberMain]];
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
    //    picker.predicateForSelectionOfProperty
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) contactPickerDidCancel: (CNContactPickerViewController *) picker {
    
    NSLog(@"contactPickerDidCancel");
}


- (void) contactPicker: (CNContactPickerViewController *) picker
      didSelectContact: (CNContact *) contact {
   
    RUFIContactStore *localContactStore = [RUFIContactStore sharedContactStore];
    
    Contact *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:localContactStore.managedObjectContext];
    
    newContact.givenName = [contact.givenName mutableCopy];
    newContact.familyName = [contact.familyName mutableCopy];
    newContact.imageData = [contact.imageData mutableCopy];
    newContact.phone = [contact.phoneNumbers mutableCopy];
    NSString * initials = [newContact.givenName substringToIndex:1];
    [initials stringByAppendingString:[contact.familyName substringToIndex:1]];
    newContact.initials = initials.uppercaseString;
    
    [[RUFIContactStore sharedContactStore]saveContext];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    NSLog(@"contactpicked: %@", contact);
    self.contact1 = [contact mutableCopy];
    self.isContactePicked = YES;
    NSLog(@"copy set to property: %@", self.contact1);
    [self updateButtonWithPicture];
    
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    // because this method is implemented, the picker will dismiss itself after this happens
    // here is where the contact property will come out
    NSString *contactName = [NSString stringWithFormat:@"%@ %@", contactProperty.contact.givenName, contactProperty.contact.familyName];
    NSLog(@"%@", contactName);
    if ([contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
//        [self.currentPerson setNeedsLayout];
//        [self.currentPerson layoutIfNeeded];
//        [self.currentPerson ];
        // they followed instructions and tapped a phone number!
        CNPhoneNumber *number = contactProperty.value;
        NSString *numberString = number.stringValue;
        NSLog(@"%@", numberString);
        
        // set the button to show the image and disable it
        if (contactProperty.contact.thumbnailImageData == nil) {
            [self.currentPerson setBackgroundImage:nil forState:UIControlStateNormal];
            NSMutableString *initials = [NSMutableString string];
            NSString *fullName = [NSString stringWithFormat:@"%@ %@ %@ %@", contactProperty.contact.givenName, contactProperty.contact.middleName, contactProperty.contact.nameSuffix, contactProperty.contact.familyName];
            NSArray *characters = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (NSString * character in characters) {
                if ([character length] > 0) {
                    NSString * firstLetter = [character substringToIndex:1];
                    [initials appendString:[firstLetter uppercaseString]];
                }
            }
//            [self.currentPerson.titleLabel setFont:[UIFont fontWithName:@"Zapfino" size:20.0]];
//            [self.currentPerson.titleLabel setTextColor:[UIColor blueColor]];
//            self.currentPerson.titleLabel.text = @"AV";
//            [self.currentPerson setImage:nil animated:NO];
            [self.currentPerson setTitle:initials forState:UIControlStateNormal];
        }
        else {
            UIImage *contactImage = [UIImage imageWithData:contactProperty.contact.thumbnailImageData];
            [self.currentPerson setTitle:@"" forState:UIControlStateNormal];
            [self.currentPerson setImage:contactImage forState:UIControlStateNormal];
            self.currentPerson.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        //        self.person1.userInteractionEnabled = NO;
    }
    else {
        //        NSLog(@"Alert Controller");
        //        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Warning"  message:@"select contact"  preferredStyle:UIAlertControllerStyleAlert];
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //            [self dismissViewControllerAnimated:YES completion:nil];
        //        }]];
        //        [self presentViewController:alertController animated:YES completion:nil];
        
        // they did not pick a phone number
        // present error alert and dont modify button
    }
}


//-(void)updateButtonWithPicture {
//    
//    UIImage *image = [UIImage imageWithData:self.contact1.thumbnailImageData];
//    NSLog(@"image: %@", image);
//    [self.person1 setImage:image forState:UIControlStateNormal];
//    
//}

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
            
            self.backgroundImage.frame = CGRectMake(0, 0, self.widthOfTheScreen, self.heightOfTheScreen);
            self.emergencyImageView.frame = CGRectMake(10, self.widthOfTheScreen/2-45, self.widthOfTheScreen-20, self.widthOfTheScreen-20);
            self.emergencyButton.frame = CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140);
            self.backButton.frame = CGRectMake(self.widthOfTheScreen-60, 30, 50, 50);
            self.addFriendsButton.frame = CGRectMake(self.widthOfTheScreen-60, 90, 50, 50);
            self.holdUntillTextField.frame = CGRectMake(self.widthOfTheScreen/2-150, 80, 300, 20);
            
        } else if (isLandscape) {
            
            self.backgroundImage.frame = CGRectMake(0, 0, self.heightOfTheScreen, self.widthOfTheScreen);
            self.emergencyButton.frame = CGRectMake(self.widthOfTheScreen/2-80, self.widthOfTheScreen/2-70, 140, 140);
            self.emergencyImageView.frame = CGRectMake(self.widthOfTheScreen/2-31, 0, self.widthOfTheScreen-20, self.widthOfTheScreen-20);
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



