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
    }
    return self;
}

-(void)getCrimeDataWithCompletion:(void (^)(BOOL))completionBlock
{
    [RUFICrimeDataAPI getCrimeDataWithCompletion:^(NSArray *crimeDictionaries)  {
        for (NSDictionary *crimeSingleDictionary in crimeDictionaries) {
            [self.crimeDataArray addObject:[RUFICrimes crimeFromDictionary:crimeSingleDictionary]];
        }
        completionBlock(YES);
    }];
}


@end
