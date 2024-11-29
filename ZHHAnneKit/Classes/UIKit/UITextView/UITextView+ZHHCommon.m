//
//  UITextView+ZHHCommon.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextView+ZHHCommon.h"
#import <objc/runtime.h>

@implementation UITextView (ZHHCommon)
#pragma mark - 方法交换 (Swizzling)

/// brief 替换 UITextView 的 dealloc 方法，用于释放资源和移除通知。
- (void)zhh_backoutSwizzled {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalDealloc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
        Method swizzledDealloc = class_getInstanceMethod(self.class, @selector(zhh_backout_dealloc));
        method_exchangeImplementations(originalDealloc, swizzledDealloc);
    });
}

/// @brief 替换后的 dealloc 方法，自动移除观察者并清理输入记录。
- (void)zhh_backout_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // 移除通知观察者
    [self.textTemps removeAllObjects]; // 清空输入记录
    [self zhh_backout_dealloc]; // 调用原始 dealloc 方法
}

#pragma mark - 撤销功能

/// @brief 撤销输入，相当于 Command + Z，恢复上一次输入内容。
- (void)zhh_textViewBackout {
    if (self.textTemps.count > 0) {
        [self.textTemps removeLastObject]; // 移除最后一条输入记录
        self.text = self.textTemps.lastObject ?: @""; // 恢复到上一条记录内容
    }
}

#pragma mark - 通知监听

/// @brief 添加 UITextView 的输入变化通知，用于记录输入历史。
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhh_backoutTextViewNotification:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhh_backoutTextViewNotification:) name:UITextViewTextDidChangeNotification object:self];
}

/// @brief 处理 UITextView 的通知，根据输入情况记录历史内容。
/// @param notification 通知对象
- (void)zhh_backoutTextViewNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:UITextViewTextDidBeginEditingNotification]) {
        if (self.textTemps.count == 0) {
            [self zhh_backoutTextViewChangeText:self.text]; // 初次编辑时记录内容
        }
    } else if ([notification.name isEqualToString:UITextViewTextDidChangeNotification]) {
        if ([self.textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
            // 检查中文输入法高亮区域
            UITextPosition *position = [self positionFromPosition:self.markedTextRange.start offset:0];
            if (!position) {
                [self zhh_backoutTextViewChangeText:self.text]; // 输入完成时保存内容
            }
        } else {
            [self zhh_backoutTextViewChangeText:self.text];
        }
    }
}

/// @brief 记录当前输入内容到历史数组中。
/// @param text 当前输入内容
- (void)zhh_backoutTextViewChangeText:(NSString *)text {
    if (text) {
        if ([self.textTemps.lastObject isEqualToString:text]) return; // 防止重复记录相同内容
        [self.textTemps addObject:text]; // 保存新内容
    }
}

#pragma mark - 动态属性

/// @brief 获取是否开启撤销功能。
/// @return 是否开启
- (BOOL)zhh_openBackout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

/// @brief 设置是否开启撤销功能，初始化必要配置。
/// @param openBackout 是否开启撤销功能
- (void)setZhh_openBackout:(BOOL)openBackout {
    objc_setAssociatedObject(self, @selector(zhh_openBackout), @(openBackout), OBJC_ASSOCIATION_ASSIGN);
    if (openBackout) {
        [self zhh_backoutSwizzled]; // 替换 dealloc 方法
        [self addNotification];    // 添加通知监听
    }
}

/// @brief 获取保存的输入记录。
/// @return 输入记录数组
- (NSMutableArray *)textTemps {
    NSMutableArray *temps = objc_getAssociatedObject(self, @selector(textTemps));
    if (!temps) {
        temps = [NSMutableArray array]; // 初始化记录数组
        objc_setAssociatedObject(self, @selector(textTemps), temps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return temps;
}


/// @brief  获取当前选中的字符串范围
/// 该方法返回当前 `UITextView` 或 `UITextField` 选中的文本范围，采用 `NSRange` 表示。
/// @return NSRange 选中的文本范围
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

/// @brief  选中所有文字
/// @discussion 此方法将 `UITextView` 或 `UITextField` 中的所有文本设置为选中状态。
- (void)zhh_selectAllText {
    // 获取整个文本范围，从文档开始到文档结束
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    
    // 设置选中的文本范围为整个文本
    [self setSelectedTextRange:range];
}

/// @brief  选中指定范围的文字
/// @param range NSRange范围 需要选中的文字范围
/// 该方法根据指定的 `NSRange` 选中相应的文字。
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

/// @brief  获取输入框当前输入的字符数，考虑标记文本
/// @param text 输入的文本
/// @return NSInteger 输入框的字符数
/// 该方法解决了 `UITextView` 中标记文本（如拼音）情况下字符数计算不准确的问题。
- (NSInteger)zhh_getInputLengthWithText:(NSString *)text {
    NSInteger textLength = 0;
    
    // 获取高亮部分（例如拼音标记）
    UITextRange *selectedRange = [self markedTextRange];
    if (selectedRange) {
        // 获取标记文本的内容，并计算字符数
        NSString *newText = [self textInRange:selectedRange];
        textLength = (newText.length + 1) / 2 + [self offsetFromPosition:self.beginningOfDocument toPosition:selectedRange.start] + text.length;
    } else {
        // 没有标记文本时，直接计算当前文本的长度
        textLength = self.text.length + text.length;
    }
    
    return textLength;
}
@end
