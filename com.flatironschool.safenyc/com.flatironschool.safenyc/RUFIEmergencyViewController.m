//
//  RUFIEmergencyViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/3/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIEmergencyViewController.h"
#import "RUFITutorialViewController.h"
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
@property (strong, nonatomic) DKCircleButton *currentPerson;
@property (strong, nonatomic) DKCircleButton *backButton;
@property (strong, nonatomic) DKCircleButton *infoButton;
@property (strong, nonatomic) DKCircleButton *settingsButton;
@property (strong, nonatomic) DKCircleButton *cancelButton;
@property (strong, nonatomic) DKCircleButton *okButton;

@property (strong, nonatomic) Contact *contact1;
@property (strong, nonatomic) Contact *contact2;
@property (strong, nonatomic) Contact *contact3;
@property (strong, nonatomic) Contact *contact4;
@property (strong, nonatomic) Contact *contact5;
@property (strong, nonatomic) Contact *contact6;
@property (strong, nonatomic) Contact *currentContact; // FIXME: rename to tappedContact

@property (nonatomic) NSUInteger tappedContactIndex;

@property (strong, nonatomic) NSString *thisButtonWasPressed;
@property (strong, nonatomic) MFMessageComposeViewController *composeVC;
@property (strong, nonatomic) UIImageView *backgroundImage;
@property (nonatomic) RUFIContactStore *localContactStore;
@property (strong, nonatomic) NSArray *localContacts;
@property (strong, nonatomic) NSArray *recipients;
@property (nonatomic) BOOL isSix;
@property (nonatomic) NSUInteger widthOfTheImage;
@property (strong, nonatomic) NSString *messageString;
@property (strong, nonatomic) UIView *defaultMessageChange;
@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UITextView *messageTextView;

@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {
    
    self.messageString = [NSString stringWithFormat:@"Hey! I am concerned about the neighboorhood I am in. Please check in on me, this is my location: http://maps.google.com/maps?q=%.8f,%.8f", self.myCurrnetLongitude, self.myCurrnetLatitude];
    self.composeVC.body = self.messageString;

    [super viewDidLoad];
    [self displayViewBackground];
    [self displayEmergencyImageView];
    [self displayButtons];
    
    self.localContactStore = [RUFIContactStore sharedContactStore];
    [self.localContactStore fetchData];
    self.localContacts = self.localContactStore.contacts;
    NSLog(@"\n %@ ", self.localContacts);
    
    [self setupContactButtons];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)setupContactButtons{
    for (Contact *contact in self.localContacts) {
        NSInteger index = [self.localContacts indexOfObject:contact];
        switch (index) {
            case 0:
                self.contact1 = contact;
                break;
            case 1:
                self.contact2 = contact;
                break;
            case 2:
                self.contact3 = contact;
                break;
            case 3:
                self.contact4 = contact;
                break;
            case 4:
                self.contact5 = contact;
                break;
            case 5:
                self.contact6 = contact;
                break;
            default:
                break;
        }
    }
}


-(void)setContact1:(Contact *)contact1{
    _contact1 = contact1;
    
    [self displayImageOrInitialsOfTheContact:self.contact1 onTheButton:self.person1];
 }

-(void)setContact2:(Contact *)contact2{
    _contact2 = contact2;
    
    [self displayImageOrInitialsOfTheContact:self.contact2 onTheButton:self.person2];
}

-(void)setContact3:(Contact *)contact3{
    _contact3 = contact3;
    
    [self displayImageOrInitialsOfTheContact:self.contact3 onTheButton:self.person3];
}

-(void)setContact4:(Contact *)contact4{
    _contact4 = contact4;
    [self displayImageOrInitialsOfTheContact:self.contact4 onTheButton:self.person4];
}

-(void)setContact5:(Contact *)contact5{
    _contact5 = contact5;
    [self displayImageOrInitialsOfTheContact:self.contact5 onTheButton:self.person5];
}

-(void)setContact6:(Contact *)contact6{
    _contact6 = contact6;
    [self displayImageOrInitialsOfTheContact:self.contact6 onTheButton:self.person6];
}

- (void)displayImageOrInitialsOfTheContact:(Contact *)contact onTheButton:(DKCircleButton *)button {
    
    if (!contact.imageData && contact.initials) {
        
        [button setImage:nil forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blueColor]];
        [button setTitle:contact.initials forState:UIControlStateNormal];
        
    } else if (contact.imageData) {
       
        UIImage *contactImage = [UIImage imageWithData:contact.imageData];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setImage:contactImage forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    } else {
        
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setImage:nil forState:UIControlStateNormal];
        [button setTitle:@"?" forState:UIControlStateNormal];
    }

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)displayViewBackground {
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.backgroundImage setImage:[UIImage imageNamed:@"bg15"]];
    [self.backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.backgroundImage];
    [self.view sendSubviewToBack:self.backgroundImage];

}

-(void)displayEmergencyImageView {
    
    self.widthOfTheScreen = self.view.frame.size.width;
    self.heightOfTheScreen = self.view.frame.size.height;
    self.widthOfTheImage = 375;
    if(self.view.frame.size.width <= 375){
        self.isSix = NO;
        self.emergencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.widthOfTheScreen/2-45, self.widthOfTheImage-20, self.widthOfTheImage-20)];
    } else {
        self.isSix = YES;
        self.emergencyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, self.widthOfTheScreen/2-45, self.widthOfTheImage-40, self.widthOfTheImage-40)];
    }
    [self.view addSubview:self.emergencyImageView];
    UIImage *image = [UIImage new];
    image = [UIImage imageNamed:@"emergencyImageView"];
    [self.emergencyImageView setImage:image];
    [self.emergencyImageView setContentMode:UIViewContentModeScaleAspectFit];
    self.emergencyImageView.userInteractionEnabled = YES;
    
}


- (void) displayButtons {
    
    self.backButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 30, 50, 50)];
    self.infoButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 90, 50, 50)];
    self.settingsButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheScreen-60, 150, 50, 50)];
    
    if(self.isSix){
        self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage/2-89, self.widthOfTheImage/2-90, 139, 139)];
        self.person1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(39, 17, 86, 86)];
        self.person2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-164, 17, 86, 86)];
        self.person3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-124, self.widthOfTheImage/2-62, 86, 86)];
        self.person4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-166, self.widthOfTheImage-144, 86, 86)];
        self.person5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(39, self.widthOfTheImage-144, 86, 86)];
        self.person6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(-2, self.widthOfTheImage/2-63, 86, 86)];

    } else {
        self.emergencyButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage/2-80, self.widthOfTheImage/2-80, 140, 140)];
        self.person1 = [[DKCircleButton alloc] initWithFrame:CGRectMake(43, 20, 87, 87)];
        self.person2 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-150, 20, 87, 87)];
        self.person3 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-107, self.widthOfTheImage/2-53, 87, 87)];
        self.person4 = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.widthOfTheImage-152, self.widthOfTheImage-127, 87, 87)];
        self.person5 = [[DKCircleButton alloc] initWithFrame:CGRectMake(43, self.widthOfTheImage-128, 87, 87)];
        self.person6 = [[DKCircleButton alloc] initWithFrame:CGRectMake(-1, self.widthOfTheImage/2-54, 87, 87)];
    }
    NSArray *buttons = @[self.emergencyButton, self.person1, self.person2, self.person3, self.person4, self.person5, self.person6, self.backButton, self.infoButton, self.settingsButton];
    
    for(DKCircleButton *button in buttons){
        
        if( button == self.backButton || button == self.infoButton || button == self.settingsButton) {
        
            [self.view addSubview:button];
        
        } else {
        
            [self.emergencyImageView addSubview:button];
        
        }
        button.titleLabel.font = [UIFont systemFontOfSize:22];
        button.backgroundColor = [UIColor clearColor];
        button.alpha = 1;
        
        if(button == self.emergencyButton){
        
            button.borderColor = [UIColor whiteColor];
        
        } else if (button == self.backButton){
            
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"back"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            
        } else if (button == self.infoButton){
            
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"info"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            
        } else if (button == self.settingsButton){
        
            UIImage *image = [UIImage new];
            image = [UIImage imageNamed:@"settings.png"];
            [button setImage:image forState:UIControlStateNormal];
            [button setContentMode:UIViewContentModeScaleAspectFit];
            
        } else {
        
            button.borderColor = [UIColor whiteColor];
        
        }
        button.animateTap = NO;
        [button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    }
}


-(void)pressedButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    
    if(button == self.emergencyButton){
    
        [self emergencyMessage];
        
    } else if (button == self.backButton){
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if (button == self.infoButton){
       
        /*
        RUFITutorialViewController * contributeViewController = [[RUFITutorialViewController alloc] init];
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        beView.frame = self.view.bounds;
        
        contributeViewController.view.frame = self.view.bounds;
        contributeViewController.view.backgroundColor = [UIColor clearColor];
        [contributeViewController.view insertSubview:beView atIndex:0];
        contributeViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self presentViewController:contributeViewController animated:YES completion:nil];*/

//        RUFITutorialViewController *modalVC = [[RUFITutorialViewController alloc]init];
//        [self presentViewController:modalVC animated:YES completion:nil];
        
        // commenting out the below method in a merge conflict
//warning Commented out below method in merge with  Yuchi's branch
        // [self performSegueWithIdentifier:@"contactsInfoButton" sender:nil];
        
        //TODO: show the info about the emergency button
        //      - how to add friend
        //      - how to change the default message
        //      - can we delete contact???
        [self showInfo];
        
    } else if (button == self.settingsButton){
        
        [self changeDeafaultMessage];
        
    } else {
        
        [self openContacts];
        
        self.currentPerson = button;
        
        if (button == self.person1){
        
            NSLog(@"Person 1!");
            self.tappedContactIndex = 1;
            self.currentContact = self.contact1;
            NSLog(@"Contact 1: %@; Person 1 (current contact): %@", self.contact1, self.currentContact);
            [self displayImageOrInitialsOfTheContact:self.contact1 onTheButton:self.person1];
            
        } else if (button == self.person2){
            
            NSLog(@"Person 2!");
            self.tappedContactIndex = 2;
            self.currentContact = self.contact2;
            
        } else if (button == self.person3){
            
            NSLog(@"Person 3!");
            self.tappedContactIndex = 3;
            self.currentContact = self.contact3;
            
        } else if (button == self.person4){
            
            NSLog(@"Person 4!");
            self.tappedContactIndex = 4;
            self.currentContact = self.contact4;
        
        } else if (button == self.person5){
            
            NSLog(@"Person 5!");
            self.tappedContactIndex = 5;
            self.currentContact = self.contact5;
       
        } else if (button == self.person6){
            
            NSLog(@"Person 6!");
            self.tappedContactIndex = 6;
            self.currentContact = self.contact6;
       
        }
    }
}

# pragma mark - Change the message view
-(void)changeDeafaultMessage{
   
    self.defaultMessageChange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.emergencyImageView.frame.size.width, self.emergencyImageView.frame.size.width)];
    self.defaultMessageChange.layer.cornerRadius = 5;
    self.defaultMessageChange.backgroundColor = [UIColor whiteColor];
    
    //Image Message
    UIImage *image = [UIImage imageNamed:@"message"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.defaultMessageChange.frame.size.width, 80);
    [self.defaultMessageChange addSubview:imageView];
    
    //Text View Default Message
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 100, self.defaultMessageChange.frame.size.width-80, 120)];
    self.messageTextView.text= self.messageString;
    self.messageTextView.backgroundColor = [UIColor whiteColor];
    self.messageTextView.alpha = 1;
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.borderColor = [[[UIColor grayColor]colorWithAlphaComponent:0.5]CGColor];
    self.messageTextView.layer.cornerRadius = 5;
    [self.defaultMessageChange addSubview:self.messageTextView];
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.defaultMessageChange.alpha = 0;
        
        [UIView transitionWithView:self.defaultMessageChange duration:3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.emergencyImageView addSubview:self.defaultMessageChange];
                        }
                        completion:^(BOOL finished){
                            
                        }];
        
        self.defaultMessageChange.alpha = 0.95;
    }];

    self.backButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.settingsButton.enabled = NO;
    
    [self.messageTextView becomeFirstResponder];
    
    self.cancelButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.emergencyImageView.frame.size.height-50, 100, 50, 50)];
    self.okButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.emergencyImageView.frame.size.height-50, 160, 50, 50)];
    NSArray *buttons = @[self.cancelButton, self.okButton];
    for(DKCircleButton *button in buttons){
        [self.defaultMessageChange addSubview:button];
        button.backgroundColor = [UIColor clearColor];
        button.borderColor = [UIColor whiteColor];
        UIImage *image = [UIImage new];
        if(button == self.okButton){
            image = [UIImage imageNamed:@"ok"];
        } else {
            image = [UIImage imageNamed:@"back"];
        }
        [button setImage:image forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeScaleAspectFill];
        [button addTarget:self action:@selector(pressedButtonInMessageSettings:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)pressedButtonInMessageSettings:(DKCircleButton *)button {
    
    button.animateTap = YES;
    if(button == self.okButton) {
        self.messageString = self.messageTextView.text;
        NSLog(@"Message was updated: %@", self.messageString);
    }
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.defaultMessageChange.alpha = 1;
        self.defaultMessageChange.alpha = 0;
    }];
    self.backButton.enabled = YES;
    self.infoButton.enabled = YES;
    self.settingsButton.enabled = YES;
    
}

# pragma mark - Show Info
-(void)showInfo {
    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, self.view.frame.size.height-40)];
    self.infoView.layer.cornerRadius = 5;
    self.infoView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.infoView.alpha = 0;
        
        [UIView transitionWithView:self.infoView duration:3
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.view addSubview:self.infoView];
                        }
                        completion:^(BOOL finished){
                            
                        }];
        
        self.infoView.alpha = 0.8;
    }];
    self.backButton.enabled = NO;
    self.infoButton.enabled = NO;
    self.settingsButton.enabled = NO;
    self.cancelButton = [[DKCircleButton alloc] initWithFrame:CGRectMake(self.infoView.frame.size.width-60, 30, 50, 50)];
    [self.infoView addSubview:self.cancelButton];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.borderColor = [UIColor whiteColor];
    UIImage *image = [UIImage new];
    image = [UIImage imageNamed:@"back"];
    [self.cancelButton setImage:image forState:UIControlStateNormal];
    [self.cancelButton setContentMode:UIViewContentModeScaleAspectFill];
    [self.cancelButton addTarget:self action:@selector(pressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)pressedCancelButton:(DKCircleButton *)button {
    
    button.animateTap = YES;
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.infoView.alpha = 0.5;
        self.infoView.alpha = 0;
    }];
    self.backButton.enabled = YES;
    self.infoButton.enabled = YES;
    self.settingsButton.enabled = YES;
    
}

# pragma mark - Message
-(void) emergencyMessage{
    
    if(![MFMessageComposeViewController canSendText]) {
        NSLog(@"This device can't send texts!");
        return;
    }
    
    self.composeVC = [[MFMessageComposeViewController alloc] init];
    self.composeVC.messageComposeDelegate = self;
    self.recipients = [NSArray new];

    //RECIPIENTS
    for(Contact *contact in self.localContacts){
       self.recipients = [self.recipients arrayByAddingObject:contact.phone];
    }
    self.composeVC.recipients = self.recipients;
    
    //BODY MESSAGE
    self.composeVC.body = self.messageString;
    //self.composeVC.body = [NSString stringWithFormat:@"Hey! I am concerned about the neighboorhood I am in. Please check in on me, this is my location: http://maps.google.com/maps?q=%.8f,%.8f", self.myCurrnetLongitude, self.myCurrnetLatitude];
        
    NSLog(@"%f, %f", self.myCurrnetLatitude, self.myCurrnetLongitude);
//    BOOL addedAttachment = [self addLocationAttachmentToComposeViewController:self.composeVC displayName:@"My Location" location:CLLocationCoordinate2DMake(self.myCurrnetLongitude, self.myCurrnetLatitude)];
//    
//    if(!addedAttachment) {
//        NSLog(@"Seems there was an issue adding the attachment :(");
//    }
    

    
    [self showViewController:self.composeVC sender:nil];

}

-(void) openContacts {
    
        CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
        picker.delegate = self;
        picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"phoneNumbers.@count > 0"];
        [self presentViewController:picker animated:YES completion:nil];
        //picker.displayedPropertyKeys = @[@[CNContactImageDataKey], @[CNContactGivenNameKey], @[CNContactFamilyNameKey], @[CNLabelPhoneNumberMain]];
}

#pragma mark - Contact Picker
-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    if ([contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        
        CNPhoneNumber *number = contactProperty.value;
        NSString *numberString = number.stringValue;
        NSLog(@"%@", numberString);
        
        RUFIContactStore *localContactStore = [RUFIContactStore sharedContactStore];
        
        if (self.currentContact) {
            [localContactStore deleteContact:self.currentContact];
            self.currentContact = nil;
        }
        
        Contact *newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:localContactStore.managedObjectContext];
        
        newContact.givenName = contactProperty.contact.givenName;
        newContact.familyName = contactProperty.contact.familyName;
        newContact.imageData = [contactProperty.contact.thumbnailImageData mutableCopy];
        newContact.phone = numberString;
        NSString * initials = [newContact.givenName substringToIndex:1];
        if(newContact.familyName.length > 0){
            initials = [initials stringByAppendingString:[contactProperty.contact.familyName substringToIndex:1]];
        }
        newContact.initials = initials.uppercaseString;
        
        [localContactStore saveContext];
        [localContactStore fetchData];
        
        self.localContacts = localContactStore.contacts;
        
        switch (self.tappedContactIndex) {
            case 1:
                self.contact1 = newContact;
                break;
            case 2:
                self.contact2 = newContact;
                break;
            case 3:
                self.contact3 = newContact;
                break;
            case 4:
                self.contact4 = newContact;
                break;
            case 5:
                self.contact5 = newContact;
                break;
            case 6:
                self.contact6 = newContact;
                break;
            default:
                break;
        }
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
}


#pragma mark - Transition to Size
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    BOOL isPortrait = size.height > size.width;
    BOOL isLandscape = size.width > size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        
       if (isPortrait){
           NSLog(@"Portrait mode");
           self.backgroundImage.frame = CGRectMake(0, 0, self.widthOfTheScreen, self.heightOfTheScreen);
           if (self.isSix & isPortrait ){
              
               self.emergencyImageView.frame = CGRectMake(40, self.widthOfTheScreen/2-45, self.widthOfTheImage-20, self.widthOfTheImage-20);
               self.person1.frame = CGRectMake(42, 20, 88, 88);
               self.person2.frame = CGRectMake(self.widthOfTheImage-151, 20, 88, 88);
               self.person3.frame = CGRectMake(self.widthOfTheImage-107, self.widthOfTheImage/2-53, 88, 88);
               self.person4.frame = CGRectMake(self.widthOfTheImage-152, self.widthOfTheImage-128, 88, 88);
               self.person5.frame = CGRectMake(43, self.widthOfTheImage-128, 88, 88);
               self.person6.frame = CGRectMake(-2, self.widthOfTheImage/2-55, 88, 88);
           
           } else {
              
               self.emergencyImageView.frame = CGRectMake(10, self.widthOfTheImage/2-45, self.widthOfTheImage-20, self.widthOfTheImage-20);
           
           }
           self.emergencyButton.frame = CGRectMake(self.widthOfTheImage/2-80, self.widthOfTheImage/2-80, 140, 140);
           self.backButton.frame = CGRectMake(self.widthOfTheScreen-60, 30, 50, 50);
           self.infoButton.frame = CGRectMake(self.widthOfTheScreen-60, 90, 50, 50);
           self.settingsButton.frame = CGRectMake(self.widthOfTheScreen-60, 150, 50, 50);
           
           //NSLog(@"View frame: %lu, %lu", self.view.frame.size.width-20, self.view.frame.size.height-40);
           self.infoView.frame = CGRectMake(10, 20, self.widthOfTheScreen-20, self.heightOfTheScreen-40);
           self.cancelButton.frame = CGRectMake(self.widthOfTheScreen-60, 30, 50, 50);
            
        } else if (isLandscape) {
            
            self.backgroundImage.frame = CGRectMake(0, 0, self.heightOfTheScreen, self.widthOfTheScreen);
            self.emergencyButton.frame = CGRectMake(self.widthOfTheImage/2-80, self.widthOfTheImage/2-80, 140, 140);
            if (self.isSix){
                
                self.emergencyImageView.frame = CGRectMake(self.widthOfTheScreen/2-11, 20, self.widthOfTheImage-20, self.widthOfTheImage-20);
                self.person1.frame = CGRectMake(42, 20, 88, 88);
                self.person2.frame = CGRectMake(self.widthOfTheImage-151, 20, 88, 88);
                self.person3.frame = CGRectMake(self.widthOfTheImage-107, self.widthOfTheImage/2-53, 88, 88);
                self.person4.frame = CGRectMake(self.widthOfTheImage-152, self.widthOfTheImage-128, 88, 88);
                self.person5.frame = CGRectMake(43, self.widthOfTheImage-128, 88, 88);
                self.person6.frame = CGRectMake(-2, self.widthOfTheImage/2-55, 89, 89);
            
            } else {
               
                self.emergencyImageView.frame = CGRectMake(self.widthOfTheImage/2-31, 0, self.widthOfTheImage-20, self.widthOfTheImage-20);
            
            }
            self.backButton.frame = CGRectMake(self.heightOfTheScreen-60, 30, 50, 50);
            self.infoButton.frame = CGRectMake(self.heightOfTheScreen-60, 90, 50, 50);
            self.settingsButton.frame = CGRectMake(self.heightOfTheScreen-60, 150, 50, 50);
            self.infoView.frame = CGRectMake(10, 20, self.heightOfTheScreen-20, self.widthOfTheScreen-40);
            self.cancelButton.frame = CGRectMake(self.heightOfTheScreen-80, 30, 50, 50);
        
        }
        [self.view layoutIfNeeded];
    }];
}

# pragma mark - Emergency Button -> MESSAGE
-(BOOL)addLocationAttachmentToComposeViewController:(MFMessageComposeViewController *)composeVC displayName:(NSString *)displayName location:(CLLocationCoordinate2D)location {
    
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

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end



