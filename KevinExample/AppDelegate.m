//
//  AppDelegate.m
//  KevinExample
//
//  Created by 何 峙 on 14-3-27.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

- (void)initShareSDK;


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self initShareSDK];

    [self enableBackgroundTask];
    
    NSDictionary *dict = @{kUserKeyMahangAcidentDays: @(633)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor blackColor];
    
    ViewController *mainVC = [[ViewController alloc] init];
    _window.rootViewController = mainVC;
    
    [_window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [application endBackgroundTask:bgTask];
            bgTask = UIBackgroundTaskInvalid;
            
        });
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private methods

- (void)initShareSDK{
    [ShareSDK registerApp:kShareSDKAppKey
     
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         
              switch (platformType) {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:kWeiboAppKey
                                                appSecret:kWeiboAppSecret
                                              redirectUri:kWeiboRedirectUri
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

#pragma mark - Public methods

- (void)enableBackgroundTask{
    if(!_locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
}

- (void)disableBackgroundTask{
    if(_locationManager){
        [_locationManager stopUpdatingLocation];
    }    
}

#pragma mark - CLLocationManagerDeleagte

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//        [_locationManager startUpdatingLocation];
//    }
    
    [_locationManager startUpdatingLocation];
}

@end
