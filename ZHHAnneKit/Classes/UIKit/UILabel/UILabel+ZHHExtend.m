//
//  UILabel+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UILabel+ZHHExtend.h"

@implementation UILabel (ZHHExtend)
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font {
    return [self zhh_labelWithColor:color font:font alignment:NSTextAlignmentLeft];
}

+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    [label sizeToFit];
    return label;
}

/// 获取宽度
- (CGFloat)zhh_calculateWidth{
    self.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [UILabel zhh_calculateLabelSizeWithTitle:self.text
                                                     font:self.font
                                        constrainedToSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    return ceil(size.width);
}
/// 获取高度
- (CGFloat)zhh_calculateHeightWithWidth:(CGFloat)width{
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [UILabel zhh_calculateLabelSizeWithTitle:self.text
                                                     font:self.font
                                        constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                            lineBreakMode:NSLineBreakByCharWrapping];
    return ceil(size.height);
}
/// 获取高度，指定行高
- (CGFloat)zhh_calculateHeightWithWidth:(CGFloat)width oneLineHeight:(CGFloat)height{
    CGFloat newHeight = [self zhh_calculateHeightWithWidth:width];
    return newHeight * height / self.font.lineHeight;
}
/// 获取文字尺寸
+ (CGSize)zhh_calculateLabelSizeWithTitle:(NSString *)title
                                    font:(UIFont *)font
                       constrainedToSize:(CGSize)size
                           lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (title.length == 0) return CGSizeZero;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph};
    CGRect frame = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    return frame.size;
}
- (void)zhh_changeLineSpace:(float)space {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                             range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)zhh_changeLineSpace:(float)space paragraphSpace:(float)paragraphSpace{
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [paragraphStyle setParagraphSpacing:paragraphSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)zhh_changeWordSpace:(float)space {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:labelText
                                                   attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}
- (void)zhh_changeLineSpace:(float)lineSpace wordSpace:(float)wordSpace {
    NSString *labelText = self.text;
    if (!labelText) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                                   initWithString:labelText
                                                   attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

- (void)zhh_setTextFont:(UIFont * _Nonnull)font fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(fromIndex, toIndex - fromIndex)];
    [self setAttributedText:attributedString];
}

- (void)zhh_labelTextAttributesWithLineSpace:(CGFloat)lineSpace firstLineHeadIndent:(CGFloat)firstLineHeadIndent fontSize:(CGFloat)fontSize color:(UIColor *)color{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = lineSpace;
    //首行缩进 (缩进个数 * 字号)
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent * fontSize;
    
    NSDictionary *attributeDic = @{
                                    NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                    NSParagraphStyleAttributeName : paragraphStyle,
                                    NSForegroundColorAttributeName : color
                                    };
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributeDic];
}

@end
