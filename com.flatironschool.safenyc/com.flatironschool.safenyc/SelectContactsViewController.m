//
//  RUFIEmergency.m
//  com.flatironschool.safenyc
//
//  Created by Yuchi Zhu on 4/5/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "SelectContactsViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>

@interface SelectContactsViewController () <CNContactPickerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItem;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *contactButton1;
@property (weak, nonatomic) IBOutlet UIButton *contactButton2;
@property (weak, nonatomic) IBOutlet UIButton *contactButton3;
@property (weak, nonatomic) IBOutlet UIButton *contactButton4;
@property (weak, nonatomic) IBOutlet UIButton *contactButton5;
@property (weak, nonatomic) IBOutlet UIButton *contactButton6;

@end

@implementation SelectContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactButton1.layer.cornerRadius = self.contactButton1.frame.size.width / 2;
    self.contactButton1.clipsToBounds = YES;
    // ^DONT FORGET TO DO THIS FOR ALL YER BUTTONS (in storyboard "clip subviews")
    
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
//    picker.predicateForSelectionOfProperty
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    // because this method is implemented, the picker will dismiss itself after this happens
    // here is where the contact property will come out
    NSString *contactName = [NSString stringWithFormat:@"%@ %@", contactProperty.contact.givenName, contactProperty.contact.familyName];
    NSLog(@"%@", contactName);
    
    if ([contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        // they followed instructions and tapped a phone number!
        CNPhoneNumber *number = contactProperty.value;
        NSString *numberString = number.stringValue;
        NSLog(@"%@", numberString);
        
        // set the button to show the image and disable it
        if (contactProperty.contact.thumbnailImageData == nil) {
            NSMutableString *initals = [NSMutableString string];
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", contactProperty.contact.givenName, contactProperty.contact.familyName];
            NSArray *characters = [fullName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            for (NSString * character in characters) {
                if ([character length] > 0) {
                    NSString * firstLetter = [character substringToIndex:1];
                    [initals appendString:[firstLetter uppercaseString]];
                }
            }
            [self.contactButton1 setTitle:initals forState:UIControlStateNormal];
        }
        else {
        UIImage *contactImage = [UIImage imageWithData:contactProperty.contact.thumbnailImageData];
        [self.contactButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.contactButton1 setImage:contactImage forState:UIControlStateNormal];
        self.contactButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
//        self.contactButton1.userInteractionEnabled = NO;
    }
    else {
//        NSLog(@"Alert Controller");
//        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Warning"  message:@"select contact"  preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        [self presentViewController:alertController animated:YES completion:nil];
        
        // they were dumb and picked not a phone number
        // present error alert and dont modify button
    }
    
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
