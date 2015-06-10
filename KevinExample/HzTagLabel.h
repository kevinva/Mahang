//
//  HzTagLabel.h
//  KevinExample
//
//  Created by 何 峙 on 14-4-9.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HzTagLabelDelegate;

@interface HzTagLabel : UIView

@property (nonatomic, retain) NSString *mainText;
@property (nonatomic, retain) NSString *tagText;
@property (nonatomic, retain) UIColor *mainTextColor;
@property (nonatomic, retain) UIFont *mainTextFont;
@property (nonatomic, retain) UIFont *tagTextFont;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) id<HzTagLabelDelegate> delegate;

- (void)refresh;
+ (CGFloat)calculateHeightForWidth:(CGFloat)w mainText:(NSString *)main tagText:(NSString *)tag font:(UIFont *)font lineSpace:(CGFloat)space;

@end

@protocol HzTagLabelDelegate <NSObject>

- (void)didClickTag:(HzTagLabel *)label;

@end
