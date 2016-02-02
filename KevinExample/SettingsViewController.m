//
//  SettingsViewController.m
//  KevinExample
//
//  Created by ZanderHo on 16/2/2.
//  Copyright © 2016年 何 峙. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *dayField;

@end

@implementation SettingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayField.text = [NSString stringWithFormat:@"%ld", self.day];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.dayField becomeFirstResponder];
}


#pragma mark - Events response

- (IBAction)okAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(settingsViewController:didSaveWithDay:)]) {
        [self.delegate settingsViewController:self didSaveWithDay:self.dayField.text.integerValue];
    }
    
    [self backAction:nil];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.dayField resignFirstResponder];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
