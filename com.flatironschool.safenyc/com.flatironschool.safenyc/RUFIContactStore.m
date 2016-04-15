//
//  RUFIContactStore.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/11/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIContactStore.h"
#import "Contact.h"

@interface RUFIContactStore ()

@end

@implementation RUFIContactStore
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype )sharedContactStore {
    static RUFIContactStore *_sharedContactStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedContactStore = [[RUFIContactStore alloc] init];
    });
    
    return _sharedContactStore;
}

- (void)saveContext {
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)deleteContact:(Contact *)contact{
    NSLog(@"deleting %@ %@", contact.givenName, contact.familyName);
    // remove the contact from self.contacts
    // delete the contact using self.managedObjectContext
    [self.managedObjectContext deleteObject:contact];
    [self saveContext];
    [self fetchData];
    NSLog(@"Now contacts are:");
    for (Contact *contact in self.contacts) {
        NSLog(@"%@ %@", contact.givenName, contact.familyName);
    }
    
}

#pragma mark - Core Data Stack

// Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RUFIContact.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RUFIContact" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)fetchData {
    
    NSFetchRequest *allItemsRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
//    allItemsRequest.sortDescriptors = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    self.contacts = [self.managedObjectContext executeFetchRequest:allItemsRequest error:nil];
    
}

@end
