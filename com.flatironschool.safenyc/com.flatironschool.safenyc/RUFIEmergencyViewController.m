//
//  RUFIEmergencyViewController.m
//  com.flatironschool.safenyc
//
//  Created by Irina Kalashnikova on 4/3/16.
//  Copyright © 2016 Irina Kalashnikova. All rights reserved.
//

#import "RUFIEmergencyViewController.h"


@interface RUFIEmergencyViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItem;


@end

@implementation RUFIEmergencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

//-(void)addContactPicker {
//    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
//    [self.contactPickerView setPlaceholderLabelText:@"Who would you like to message?"];
//    self.contactPickerView.delegate = self;
//    [self.view addSubview:self.contactPickerView];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelItem:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addItem:(id)sender {
    
}

@end
