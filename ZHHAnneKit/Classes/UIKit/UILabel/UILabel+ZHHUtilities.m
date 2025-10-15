//
//  UILabel+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UILabel+ZHHUtilities.h"
#import "UIView+ZHHFrame.h"
#import <objc/runtime.h>

@implementation UILabel (ZHHUtilities)

+ (void)load {
    SEL selectors[] = {
        @selector(textRectForBounds:limitedToNumberOfLines:),
        @selector(drawTextInRect:),
    };

    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"_zhh_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

        if (originalMethod && swizzledMethod) {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

/**
 重写 textRectForBounds:limitedToNumberOfLines: 方法，增加对 zhh_edgeInsets 的支持。

 @param bounds UILabel 的原始 bounds
 @param numberOfLines 限制的最大行数
 @return 添加内边距后调整的文本区域
 */
- (CGRect)_zhh_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_edgeInsets)) {
        return [self _zhh_textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }

    // 根据内边距调整文本区域
    CGRect rect = [self _zhh_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.zhh_edgeInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.zhh_edgeInsets.left;
    rect.origin.y -= self.zhh_edgeInsets.top;
    rect.size.width += self.zhh_edgeInsets.left + self.zhh_edgeInsets.right;
    rect.size.height += self.zhh_edgeInsets.top + self.zhh_edgeInsets.bottom;
    return rect;
}

/**
 重写 drawTextInRect: 方法，支持 zhh_edgeInsets。

 @param rect UILabel 的绘制区域
 */
- (void)_zhh_drawTextInRect:(CGRect)rect {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, self.zhh_edgeInsets)) {
        [self _zhh_drawTextInRect:rect];
    } else {
        [self _zhh_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.zhh_edgeInsets)];
    }
}

/**
 获取 UILabel 的文本内边距（zhh_edgeInsets）。

 @return 文本的内边距
 */
- (UIEdgeInsets)zhh_edgeInsets {
    return [objc_getAssociatedObject(self, _cmd) UIEdgeInsetsValue];
}

/**
 设置 UILabel 的文本内边距（zhh_edgeInsets）。

 @param zhh_edgeInsets 文本内边距
 */
- (void)setZhh_edgeInsets:(UIEdgeInsets)zhh_edgeInsets {
    if (UIEdgeInsetsEqualToEdgeInsets(UIEdgeInsetsZero, zhh_edgeInsets)) return;
    NSValue *value = [NSValue valueWithUIEdgeInsets:zhh_edgeInsets];
    objc_setAssociatedObject(self, @selector(zhh_edgeInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // 重新布局
    [self setNeedsDisplay];
}


/**
 * 快速创建一个 UILabel，默认左对齐。
 *
 * @param color 文字颜色
 * @param font 字体
 * @return 返回一个设置好颜色和字体的 UILabel 实例
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font {
    return [self zhh_labelWithColor:color font:font alignment:NSTextAlignmentLeft];
}

/**
 * 快速创建一个 UILabel，并自定义颜色、字体和对齐方式。
 *
 * @param color 文字颜色
 * @param font 字体
 * @param alignment 文本对齐方式（NSTextAlignmentLeft、NSTextAlignmentCenter、NSTextAlignmentRight 等）
 * @return 返回一个自定义设置的 UILabel 实例
 */
+ (instancetype)zhh_labelWithColor:(UIColor *)color font:(UIFont *)font alignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = font;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    // 调整尺寸以适应当前内容（默认内容为空）
    [label sizeToFit];
    return label;
}

/// 获取当前 UILabel 文本的宽高
- (CGSize)zhh_labelSize {
    return [UILabel zhh_labelSizeWithText:self.text width:self.zhh_width height:self.zhh_height font:self.font];
}

/// 根据文本、宽度、高度和字体计算文本所占的宽高
/// @param text 文本内容
/// @param width 最大宽度
/// @param height 最大高度
/// @param font 字体
/// @return 文本所占的宽高
+ (CGSize)zhh_labelSizeWithText:(NSString *)text width:(CGFloat)width height:(CGFloat)height font:(UIFont *)font {
    if (text.length == 0 || font == nil) {
        return CGSizeZero; // 如果文本为空或字体为空，直接返回 CGSizeZero
    }

    CGSize boundingSize = CGSizeZero;
    if (width > 0) {
        boundingSize.width = width;
    } else {
        boundingSize.width = MAXFLOAT; // 如果宽度为 0，则不限制宽度
    }

    if (height > 0) {
        boundingSize.height = height;
    } else {
        boundingSize.height = MAXFLOAT; // 如果高度为 0，则不限制高度
    }

    CGRect boundingRect = [text boundingRectWithSize:boundingSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: font}
                                             context:nil];
    return boundingRect.size;
}

#pragma mark - UILabel 文本样式调整
/// 修改 UILabel 的行间距。
/// @param lineSpacing 行间距大小
- (void)zhh_adjustLineSpacing:(CGFloat)lineSpacing {
    NSString *text = self.text;
    if (!text) return; // 确保文本非空

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 设置行间距

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attributedString;
    [self sizeToFit]; // 自动调整控件大小
}

/// 修改 UILabel 的行间距和段间距。
/// @param lineSpacing 行间距大小
/// @param paragraphSpacing 段间距大小
- (void)zhh_adjustLineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing {
    NSString *text = self.text;
    if (!text) return; // 确保文本非空

    // 创建属性字符串和段落样式
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 设置行间距
    paragraphStyle.paragraphSpacing = paragraphSpacing; // 设置段间距

    // 添加段落样式属性
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attributedString;
    
    // 调整 UILabel 尺寸
    [self sizeToFit];
}

/// 设置 UILabel 的字间距（字符间距）。
/// @param wordSpacing 字间距大小（以点为单位，正值增大间距，负值减小间距）。
- (void)zhh_adjustSpacingWithLine:(CGFloat)wordSpacing {
    // 获取 UILabel 的文本内容
    NSString *text = self.text;
    if (!text || text.length == 0) return; // 文本为空时直接返回
    // 创建一个可变的属性字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置字间距
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, text.length)];
    // 应用到 UILabel 的 attributedText
    self.attributedText = attributedString;
    // 自动调整 UILabel 的大小
    [self sizeToFit];
}

/// 设置 UILabel 的行间距和字间距。
/// @param lineSpacing 行间距大小（段落中每行之间的距离）。
/// @param wordSpacing 字间距大小（字符之间的距离）。
- (void)zhh_adjustSpacingWithLine:(CGFloat)lineSpacing wordSpacing:(CGFloat)wordSpacing {
    // 获取 UILabel 的文本内容
    NSString *text = self.text;
    if (!text || text.length == 0) return; // 确保文本非空

    // 创建可变的属性字符串
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 设置字间距
    if (wordSpacing != 0) {
        [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, text.length)];
    }

    // 设置行间距
    if (lineSpacing != 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = lineSpacing; // 设置行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    }

    // 应用属性字符串到 UILabel
    self.attributedText = attributedString;

    // 自动调整 UILabel 大小
    [self sizeToFit];
}

/// 配置 UILabel 文本的行间距、首行缩进、字体和颜色。
/// @param lineSpacing 行间距大小
/// @param firstLineIndent 首行缩进字符数
/// @param font 字体对象
/// @param color 字体颜色
- (void)zhh_configureTextWithLineSpacing:(CGFloat)lineSpacing
                         firstLineIndent:(CGFloat)firstLineIndent
                                    font:(UIFont *)font
                                   color:(UIColor *)color {
    // 检查文本内容是否为空
    if (!self.text || self.text.length == 0) return;

    // 创建段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing; // 设置行间距
    paragraphStyle.firstLineHeadIndent = firstLineIndent * font.pointSize; // 首行缩进（字符数 * 字体大小）

    // 定义文本属性
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle,
        NSForegroundColorAttributeName: color
    };

    // 设置富文本
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
}

@end
