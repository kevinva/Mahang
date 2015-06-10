//
//  ViewController.m
//  KevinExample
//
//  Created by 何 峙 on 14-3-27.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import "ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "HzTagLabel.h"

static NSString *const kFilePostingMessageLog = @"log_posting_message.plist";

@interface UITextView (HTML)

- (void)setContentToHTMLString:(NSString *)str;

@end

@interface ViewController () <UIAlertViewDelegate>{
    
    NSTimer *publishTimer;
    NSInteger seconds;
    
}

@property (nonatomic, weak) IBOutlet UILabel *weiboNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *boundWeiboButton;
@property (nonatomic, weak) IBOutlet UILabel *secondsLabel;
@property (nonatomic, weak) IBOutlet UILabel *daysLabel;
@property (nonatomic, strong) HzTagLabel *tagLabel;

- (void)initLayout;
- (IBAction)boundOrUnboundWeibo:(id)sender;
- (IBAction)testPublish:(id)sender;
- (void)postMsgWithDays:(NSInteger)days;

@end

@implementation ViewController

- (void)dealloc{
    if(publishTimer){
        [publishTimer invalidate];
        publishTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    seconds = 23 * 3600;
    
    [self initLayout];
    
    publishTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeToRequestPublishMessage:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)initLayout{
    if([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]){
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKeyWeiboUserName];
        _weiboNameLabel.text = userName;
        
        [_boundWeiboButton setTitle:@"取消绑定新浪微博" forState:UIControlStateNormal];
    }
    else{
        _weiboNameLabel.text = @"xxx";
        [_boundWeiboButton setTitle:@"绑定新浪微博" forState:UIControlStateNormal];
    }
    
    NSInteger days = [[NSUserDefaults standardUserDefaults] integerForKey:kUserKeyMahangAcidentDays];    
    _daysLabel.text = [NSString stringWithFormat:@"第%d天", days];
    
//    NSString *tagText = @"京东京东京";
//    NSString *mainText = @"哈哈哈哈哈哈drwer哈哈哈哈哈哈drwer哈哈哈哈哈哈drwer哈哈哈哈!";
//    self.tagLabel = [[HzTagLabel alloc] init];
//    _tagLabel.mainText = mainText;
//    _tagLabel.tagText = tagText;
//    _tagLabel.mainTextColor = [UIColor blackColor];
//    _tagLabel.mainTextFont = [UIFont systemFontOfSize:17.0f];
//    _tagLabel.tagTextFont = [UIFont systemFontOfSize:14.0f];
//    _tagLabel.lineSpace = 20.0f;
//    CGRect rect = _tagLabel.frame;
//    rect.origin.x = 20.0f;
//    rect.origin.y = 400.0f;
//    rect.size.width = 250.0f;
//    _tagLabel.frame = rect;
//    [self.view addSubview:_tagLabel];
    
}

- (void)postMsgWithDays:(NSInteger)days{
    NSString *content = [NSString stringWithFormat:@"#马航飞机失事# 第%d天[蜡烛]", days];
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:nil
                                                image:nil
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeText];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        
                        if(state == SSResponseStateSuccess){
                            [[NSUserDefaults standardUserDefaults] setInteger:days forKey:kUserKeyMahangAcidentDays];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        
                        if(end){
                            NSString *filePath = [kDirDocument stringByAppendingPathComponent:kFilePostingMessageLog];
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
                            if(!dict){
                                dict = [[NSMutableDictionary alloc] init];
                            }
                            
                            if(!error || (NSNull *)error == [NSNull null]){
                                [dict setObject:@"ok" forKey:[NSDate date].description];
                            }
                            else{
                                [dict setObject:error.errorDescription forKey:[NSDate date].description];
                            }
                            [dict writeToFile:filePath atomically:YES];                            
                            
                        }
                        
                    }];
}

#pragma mark - Action control

- (IBAction)boundOrUnboundWeibo:(id)sender{
    if([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确定取消绑定？"
                                                           delegate:self
                                                  cancelButtonTitle:@"算了"
                                                  otherButtonTitles:@"好吧", nil];
        [alertView show];
    }
    else{
        [ShareSDK authWithType:ShareTypeSinaWeibo options:nil result:^(SSAuthState state, id<ICMErrorInfo> error) {
            
            if(state == SSAuthStateSuccess){
                
                [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                    
                    if(result){
                        [[NSUserDefaults standardUserDefaults] setObject:userInfo.nickname forKey:kUserKeyWeiboUserName];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        
                        _weiboNameLabel.text = userInfo.nickname;
                        [_boundWeiboButton setTitle:@"取消绑定新浪微博" forState:UIControlStateNormal];
                    }
                    
                }];
                
            }
            else if(state == SSAuthStateFail){
                NSLog(@"%s, error: %@", __FUNCTION__, error.errorDescription);
            }
            
        }];
    }
}

- (IBAction)testPublish:(id)sender{
    NSInteger days = [[NSUserDefaults standardUserDefaults] integerForKey:kUserKeyMahangAcidentDays];
    days++;
    _daysLabel.text = [NSString stringWithFormat:@"第%d天", days];
    [self postMsgWithDays:days];
//    _tagLabel.tagText = nil;
//    _tagLabel.lineSpace = 10.0f;
//    [_tagLabel refresh];
}

#pragma mark - NSTimer callback

- (void)timeToRequestPublishMessage:(NSTimer *)timer{
    seconds++;
    
    _secondsLabel.text = [NSString stringWithFormat:@"%d", seconds];
    
    NSLog(@"%s, second: %d, backgroundTimeRemaining: %f", __FUNCTION__, seconds, [UIApplication sharedApplication].backgroundTimeRemaining);
    
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    if(seconds % 10 == 0){
        [appDelegate disableBackgroundTask];
        
    }
    
    if(seconds % 25 == 0){
        [appDelegate enableBackgroundTask];
    }
    
    if(seconds == 24 * 3600){
        seconds = 0;
        
        NSLog(@"fire!");
        
        NSInteger days = [[NSUserDefaults standardUserDefaults] integerForKey:kUserKeyMahangAcidentDays];
        days++;
        _daysLabel.text = [NSString stringWithFormat:@"第%d天", days];
        [self postMsgWithDays:days];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        
        _weiboNameLabel.text = @"xxx";
        [_boundWeiboButton setTitle:@"绑定新浪微博" forState:UIControlStateNormal];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserKeyWeiboUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
