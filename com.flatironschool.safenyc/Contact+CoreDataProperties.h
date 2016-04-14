//
//  Contact+CoreDataProperties.h
//  
//
//  Created by Irina Kalashnikova on 4/13/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *familyName;
@property (nullable, nonatomic, retain) NSString *givenName;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *initials;
@property (nullable, nonatomic, retain) NSString *phone;

@end

NS_ASSUME_NONNULL_END
