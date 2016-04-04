//
//  RUFIDataStore.m
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 3/30/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIDataStore.h"
#import "RUFICrimeDataAPI.h"
#import "RUFICrimes.h"

@implementation RUFIDataStore

+ (instancetype)sharedDataStore {
    static RUFIDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[RUFIDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _crimeDataArray=[NSMutableArray new];
        _userLatitude = [NSString new];
        _userLongitude = [NSString new];
        _distanceInMeters = [NSString new];
        _yearsAgo = [NSString new];
    }
    return self;
}

-(void)getCrimeDataWithCompletion:(void (^)(BOOL finished))completionBlock
{
    
    NSLog(@"GETTING TO HERE");
    NSLog(@"AT DATA STORE %@", self.userLatitude);
    NSLog(@"AT DATA STORE %@", self.userLongitude);
    [self resetCountsToZero];
    [self.crimeDataArray removeAllObjects];
    
    [RUFICrimeDataAPI getCrimeDataFromLatitude:self.userLatitude longitude:self.userLongitude withCompletion:^(NSArray * crimeDictionaries) {
        

        for (NSDictionary *crimeSingleDictionary in crimeDictionaries) {
            [self checkCrimeType:crimeSingleDictionary];
            [self.crimeDataArray addObject:[RUFICrimes crimeFromDictionary:crimeSingleDictionary]];
        }
        
        NSLog(@"%@", self.crimeDataArray);
        completionBlock(YES);
    }];
}

-(void)checkCrimeType:(NSDictionary *)crimes {
    
    if ([crimes[@"offense"] isEqualToString:@"GRAND LARCENY"]) {
        
        self.grandLarcenyCount += 1;
    
    }
    
    if ([crimes[@"offense"] isEqualToString:@"FELONY ASSAULT"]) {
        
        self.felonyAssaultCount += 1;

    }
    
    if ([crimes[@"offense"] isEqualToString:@"GRAND LARCENY OF MOTOR VEHICLE"]) {
        
        self.grandLarcenyMVCount += 1;
        
    }
    
    if ([crimes[@"offense"] isEqualToString:@"MURDER & NON-NEGL. MANSLAUGHTE"]) {
        
        self.murderCount += 1;
        
    }
    
    if ([crimes[@"offense"] isEqualToString:@"RAPE"]) {
        
        self.rapeCount += 1;

    }
    
    if ([crimes[@"offense"] isEqualToString:@"ROBBERY"]) {
        
        self.robberyCount += 1;

    }
    
    if ([crimes[@"offense"] isEqualToString:@"BURGLARY"]) {
        
        self.burglaryCount += 1;

    }
    
}

-(void)resetCountsToZero {
    
    self.burglaryCount = 0;
    self.robberyCount = 0;
    self.rapeCount = 0;
    self.murderCount = 0;
    self.grandLarcenyMVCount = 0;
    self.felonyAssaultCount = 0;
    self.grandLarcenyCount = 0;
    
}


@end
