//
//  HzLabel.m
//  HzTest2
//
//  Created by 何 峙 on 13-9-29.
//  Copyright (c) 2013年 何 峙. All rights reserved.
//

#import "HzLabel.h"
#import <CoreText/CoreText.h>

@interface HzLabel ()

- (NSAttributedString *)stylishString;

@end

@implementation HzLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    self.text = nil;
    self.textColor = nil;
    self.font = nil;
    
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //[super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    

    NSAttributedString *attributedString = [self stylishString];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path, NULL);
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

#pragma mark - Private methods

- (NSAttributedString *)stylishString{
    if(_text){
        //设置断行方式
        CTParagraphStyleSetting lineBreak;
        CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
        lineBreak.spec = kCTParagraphStyleSpecifierLineBreakMode;
        lineBreak.value = &lineBreakMode;
        lineBreak.valueSize = sizeof(CTLineBreakMode);
        
        //设置行距
        CTParagraphStyleSetting lineSpacing;
        CGFloat spacing = 8.0f;
        if(_lineSpace > 0){
            spacing = _lineSpace;
        }
        lineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpacing.value = &spacing;
        lineSpacing.valueSize = sizeof(CGFloat);
        
        CTParagraphStyleSetting settings[] = {lineBreak, lineSpacing};
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
        
        if(!_textColor){
            self.textColor = [UIColor blackColor];
        }
        
        if(!_font){
            self.font = [UIFont systemFontOfSize:17.0f];
        }
        
        CTFontRef ctFont = CTFontCreateWithName((CFStringRef)_font.fontName, _font.pointSize, NULL);
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)ctFont, kCTFontAttributeName,
                                   _textColor.CGColor, kCTForegroundColorAttributeName,
                                   (id)paragraphStyle, kCTParagraphStyleAttributeName, nil];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_text attributes:attribute];
        
        CFRelease(paragraphStyle);
        CFRelease(ctFont);
        
        return [attributedString autorelease];
    }
    
    return nil;
}

#pragma mark - Public methods

+ (CGFloat)boundingHeightForWidth:(CGFloat)w string:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)space{
    if(!text || !font || space < 0){
        return -1.0f;
    }
    
    //设置断行方式
    CTParagraphStyleSetting lineBreak;
    CTLineBreakMode lineBreakMode = kCTLineBreakByWordWrapping;
    lineBreak.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreak.value = &lineBreakMode;
    lineBreak.valueSize = sizeof(CTLineBreakMode);
    
    //设置行距
    CTParagraphStyleSetting lineSpacing;
    CGFloat spacing = space;
    lineSpacing.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpacing.value = &spacing;
    lineSpacing.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting settings[] = {lineBreak, lineSpacing};
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 2);
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)ctFont, kCTFontAttributeName,
                               (id)paragraphStyle, kCTParagraphStyleAttributeName, nil];
    NSAttributedString *attributedString = [[[NSAttributedString alloc] initWithString:text attributes:attribute] autorelease];
    
    CFRelease(paragraphStyle);
    CFRelease(ctFont);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, CGSizeMake(w, 10000), NULL);
    
    CFRelease(frameSetter);
    
    return suggestedSize.height;
}

- (void)refresh{
    [self setNeedsDisplay];
}

@end
