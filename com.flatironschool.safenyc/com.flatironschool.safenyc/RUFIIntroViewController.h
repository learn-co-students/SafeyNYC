//
//  RUFIIntroViewController.h
//  com.flatironschool.safenyc
//
//  Created by Rosario Tarabocchia on 4/12/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RUFIDataStore.h"

@interface RUFIIntroViewController : UIViewController

@property (nonatomic, strong) RUFIDataStore *dataStore;
@property (nonatomic) NSUserDefaults *agreementAccepted;

@end
