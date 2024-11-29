//
//  UITextField+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextField+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation UITextField (ZHHUtilities)
#pragma mark - 动态属性存取方法

- (id<UITextFieldHelperDelegate>)zhh_delegate {
    return objc_getAssociatedObject(self, @selector(zhh_delegate));
}

- (void)setZhh_delegate:(id<UITextFieldHelperDelegate>)zhh_delegate {
    objc_setAssociatedObject(self, @selector(zhh_delegate), zhh_delegate, OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(zhh_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 占位文字相关

- (UIColor *)zhh_placeholderColor {
    return objc_getAssociatedObject(self, @selector(zhh_placeholderColor));
}

- (void)setZhh_placeholderColor:(UIColor *)zhh_placeholderColor {
    objc_setAssociatedObject(self, @selector(zhh_placeholderColor), zhh_placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_updatePlaceholderAttributes];
}

- (CGFloat)zhh_placeholderFontSize {
    return [objc_getAssociatedObject(self, @selector(zhh_placeholderFontSize)) floatValue];
}

- (void)setZhh_placeholderFontSize:(CGFloat)zhh_placeholderFontSize {
    objc_setAssociatedObject(self, @selector(zhh_placeholderFontSize), @(zhh_placeholderFontSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self zhh_updatePlaceholderAttributes];
}

- (void)zhh_updatePlaceholderAttributes {
    if (!self.placeholder) return;

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (self.zhh_placeholderColor) {
        attributes[NSForegroundColorAttributeName] = self.zhh_placeholderColor;
    }
    if (self.zhh_placeholderFontSize > 0) {
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:self.zhh_placeholderFontSize];
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
}

#pragma mark - 最大长度相关

- (NSInteger)zhh_maxLength {
    return [objc_getAssociatedObject(self, @selector(zhh_maxLength)) integerValue];
}

- (void)setZhh_maxLength:(NSInteger)zhh_maxLength {
    objc_setAssociatedObject(self, @selector(zhh_maxLength), @(zhh_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(zhh_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 文本变化监听

- (void)zhh_textFieldChanged:(UITextField *)textField {
    NSString *currentText = textField.text ?: @"";

    // 检查是否超过最大长度
    if (self.zhh_maxLength > 0 && currentText.length > self.zhh_maxLength) {
        UITextPosition *markedTextPosition = [self markedTextRange].start;
        if (!markedTextPosition) { // 未处于中文输入时
            textField.text = [currentText substringToIndex:self.zhh_maxLength];
            if ([self.zhh_delegate respondsToSelector:@selector(textField:didReachMaxLength:)]) {
                [self.zhh_delegate textField:self didReachMaxLength:self.zhh_maxLength];
            }
        }
    }

    // 调用文本变化代理方法
    if ([self.zhh_delegate respondsToSelector:@selector(textField:didChangeText:)]) {
        [self.zhh_delegate textField:self didChangeText:textField.text];
    }
}

#pragma mark - 密码保护

- (BOOL)zhh_securePasswords {
    return [objc_getAssociatedObject(self, @selector(zhh_securePasswords)) boolValue];
}

- (void)setZhh_securePasswords:(BOOL)zhh_securePasswords {
    objc_setAssociatedObject(self, @selector(zhh_securePasswords), @(zhh_securePasswords), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *currentText = self.text;
    self.text = @""; // 清空后再赋值，防止动画问题
    self.secureTextEntry = zhh_securePasswords;
    self.text = currentText;
}

#pragma mark - 输入辅助视图

- (BOOL)zhh_displayInputAccessoryView {
    return !self.inputAccessoryView.hidden;
}

- (void)setZhh_displayInputAccessoryView:(BOOL)zhh_displayInputAccessoryView {
    self.inputAccessoryView = zhh_displayInputAccessoryView ? nil : [UIView new];
}

/**
 *  @brief  获取当前选中的字符串范围
 *
 *  @discussion 该方法返回当前 `UITextView` 或 `UITextField` 选中的文本范围，采用 `NSRange` 表示。
 *
 *  @return NSRange 选中的文本范围
 */
- (NSRange)zhh_selectedRange {
    // 获取文档的起始位置
    UITextPosition *beginning = self.beginningOfDocument;
    
    // 获取当前选中的文本范围
    UITextRange *selectedRange = self.selectedTextRange;
    
    // 获取选中开始和结束的文本位置
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    // 计算选中文本的起始位置和长度
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

/**
 *  @brief  选中所有文字
 *
 *  @discussion 此方法将 `UITextView` 或 `UITextField` 中的所有文本设置为选中状态。
 */
- (void)zhh_selectAllText {
    // 获取整个文本范围，从文档开始到文档结束
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    
    // 设置选中的文本范围为整个文本
    [self setSelectedTextRange:range];
}

/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围 需要选中的文字范围
 *
 *  @discussion 该方法根据指定的 `NSRange` 选中相应的文字。
 */
- (void)zhh_setSelectedRange:(NSRange)range {
    // 获取文档的起始位置
    UITextPosition *beginning = self.beginningOfDocument;
    
    // 获取选中开始和结束位置的 `UITextPosition`
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    
    // 创建选中的文本范围
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    // 设置选中的文本范围
    [self setSelectedTextRange:selectionRange];
}

@end
