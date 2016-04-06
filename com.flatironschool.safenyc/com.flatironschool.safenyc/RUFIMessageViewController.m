//
//  RUFIMessageViewController.m
//  com.flatironschool.safenyc
//
//  Created by Yuchi Zhu on 4/5/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "SelectContactsViewController.h"
#import "RUFIMessageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RUFIMessageViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation RUFIMessageViewController

-(IBAction)buttonTapped:(id)sender
{
    if(![MFMessageComposeViewController canSendText]) {
        NSLog(@"This device can't send texts!");
        return;
    }
    
    MFMessageComposeViewController *composeVC = [[MFMessageComposeViewController alloc] init];
    
    composeVC.messageComposeDelegate = self;
    //add recipients
    composeVC.recipients = @[@"9176506024"];
    //BODY MESSAGE
    
    composeVC.body = @"Hey! I am concerned about the neighboorhood I am in. Please check in on me, this is my location";
    
    BOOL addedAttachment = [self addLocationAttachmentToComposeViewController:composeVC displayName:@"My Location" location:CLLocationCoordinate2DMake(40.705268, -74.013986)];
    
    if(!addedAttachment) {
        NSLog(@"Seems there was an issue adding the attachment :(");
    }
    
    [self showViewController:composeVC sender:nil];
}

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
