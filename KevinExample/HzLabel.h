//
//  HzLabel.h
//  HzTest2
//
//  Created by 何 峙 on 13-9-29.
//  Copyright (c) 2013年 何 峙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HzLabel : UIView

@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;

+ (CGFloat)boundingHeightForWidth:(CGFloat)w string:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)space;
- (void)refresh;

@end
