//
//  Contact+CoreDataProperties.h
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/11/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *givenName;
@property (nullable, nonatomic, retain) NSString *familyName;
@property (nullable, nonatomic, retain) NSString *imageData;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *initials;

@end

NS_ASSUME_NONNULL_END
