//
//  UITextView+ZHHHelper.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZHHHelper)
#pragma mark - 撤销输入功能

/// @brief  开启或关闭撤销功能
/// 设置为 `YES` 时，UITextView 将开启撤销输入功能，支持手动撤销到上一状态。
@property (nonatomic, assign) BOOL zhh_openBackout;

/// @brief  手动撤销输入操作
/// @discussion 功能类似于 `Command + Z`，会将输入内容恢复到上一次的状态。
- (void)zhh_textViewBackout;

#pragma mark - 文本范围操作
/// @brief  获取当前选中的字符串范围
/// @return 返回当前选中的文本范围（NSRange）
- (NSRange)zhh_selectedRange;

/// @brief  选中所有文字
/// 将当前 `UITextView` 或 `UITextField` 的所有文本设置为选中状态。
- (void)zhh_selectAllText;

/// @brief  选中指定范围的文字
/// @param range 要选中的文本范围（NSRange）
/// 通过指定范围选中文本，传入的 `NSRange` 可以精确控制选中的文字。
- (void)zhh_setSelectedRange:(NSRange)range;

#pragma mark - 输入长度计算

/// @brief  获取输入框当前输入的字符数（考虑标记文本）
/// @param text 输入的文本
/// @return 当前输入框中的字符数（NSInteger）
/// 该方法考虑了标记文本（如拼音输入时未完成的标记文本）情况下的字符数计算，解决了传统方法不准确的问题。
- (NSInteger)zhh_getInputLengthWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
