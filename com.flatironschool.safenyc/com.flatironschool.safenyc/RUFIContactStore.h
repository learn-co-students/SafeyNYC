//
//  RUFIContactStore.h
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/11/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Contact;
@interface RUFIContactStore : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *contacts;

+ (instancetype) sharedContactStore;
-(void) saveContext;
-(void) fetchData;
-(void) deleteContact:(Contact*)contact;

@end
