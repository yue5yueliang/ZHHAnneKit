//
//  NSString+Size.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "NSString+Size.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (Size)

- (CGSize)zhh_sizeOfTextWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    NSDictionary * dict = @{NSFontAttributeName:font};
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:dict context:nil].size;
    return size;
}

+ (CGSize)zhh_sizeWithText:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    return [text zhh_sizeOfTextWithMaxWidth:maxWidth font:font];
}

- (CGSize)zhh_calculateSingleLineSizeWithAttributeText:(UIFont *)font {
    if (font == nil) { return CGSizeZero; }
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    //详细https://mp.weixin.qq.com/s/DOfnIJwfz0m7A6-vooICHg
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    //构造新的字符串对象
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    //绘制区域
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

- (CGSize)zhh_calculateSingleLineSizeFromFont:(UIFont *)font {
    if (font == nil) { return CGSizeZero; }
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

/// 获取文本宽度
- (CGFloat)zhh_maxWidthWithFont:(UIFont *)font
                         height:(CGFloat)height
                      alignment:(NSTextAlignment)alignment
                  linebreakMode:(NSLineBreakMode)linebreakMode
                      lineSpace:(CGFloat)lineSpace{
    return [self zhh_sizeWithFont:font
                             size:CGSizeMake(CGFLOAT_MAX, height)
                        alignment:alignment
                    linebreakMode:linebreakMode
                        lineSpace:lineSpace].width;
}
/// 获取文本高度
- (CGFloat)zhh_maxHeightWithFont:(UIFont *)font
                           width:(CGFloat)width
                       alignment:(NSTextAlignment)alignment
                   linebreakMode:(NSLineBreakMode)linebreakMode
                       lineSpace:(CGFloat)lineSpace{
    return [self zhh_sizeWithFont:font
                             size:CGSizeMake(width, CGFLOAT_MAX)
                        alignment:alignment
                    linebreakMode:linebreakMode
                        lineSpace:lineSpace].height;
}
- (CGSize)zhh_sizeWithFont:(UIFont *)font
                      size:(CGSize)size
                 alignment:(NSTextAlignment)alignment
             linebreakMode:(NSLineBreakMode)linebreakMode
                 lineSpace:(CGFloat)lineSpace{
    if (self.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = linebreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpace > 0) paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize newSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                     attributes:attributes context:NULL].size;
    return CGSizeMake(ceil(newSize.width), ceil(newSize.height));
}
/// 计算字符串高度尺寸，spacing为行间距
- (CGSize)zhh_textSizeWithFont:(UIFont *)font size:(CGSize)size spacing:(CGFloat)spacing{
    if (self == nil) return CGSizeMake(0, 0);
    NSDictionary *dict = @{NSFontAttributeName:font};
    if (spacing > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:spacing];
        dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    }
    size = [self boundingRectWithSize:size
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dict
                              context:nil].size;
    return size;
}

/// 文字转图片
- (UIImage *)zhh_textBecomeImageWithSize:(CGSize)size backgroundColor:(UIColor *)color textAttributes:(NSDictionary *)attributes{
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, bounds);
    CGSize textSize = [self sizeWithAttributes:attributes];
    [self drawInRect:CGRectMake(bounds.size.width/2-textSize.width/2,
                                bounds.size.height/2-textSize.height/2,
                                textSize.width,
                                textSize.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
