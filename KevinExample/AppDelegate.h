//
//  AppDelegate.h
//  KevinExample
//
//  Created by 何 峙 on 14-3-27.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    
}

@property (strong, nonatomic) UIWindow *window;

- (void)enableBackgroundTask;
- (void)disableBackgroundTask;

@end
