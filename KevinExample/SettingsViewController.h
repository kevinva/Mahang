//
//  SettingsViewController.h
//  KevinExample
//
//  Created by ZanderHo on 16/2/2.
//  Copyright © 2016年 何 峙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UIViewController

@property (nonatomic,   weak) id<SettingsViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger day;

@end

@protocol SettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(SettingsViewController *)controller didSaveWithDay:(NSInteger)day;

@end
