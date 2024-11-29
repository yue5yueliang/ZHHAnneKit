//
//  UITextField+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UITextFieldHelperDelegate;
@protocol UITextFieldHelperDelegate <NSObject>

@optional
/// 当文本内容发生变化时回调
- (void)textField:(UITextField *)textField didChangeText:(NSString *)text;

/// 当输入达到最大长度时回调
- (void)textField:(UITextField *)textField didReachMaxLength:(NSInteger)maxLength;

@end

IB_DESIGNABLE
@interface UITextField (ZHHUtilities)
/// 占位文字颜色（支持 XIB）
@property (nonatomic, strong) IBInspectable UIColor *zhh_placeholderColor;
/// 占位文字字体大小（支持 XIB）
@property (nonatomic, assign) IBInspectable CGFloat zhh_placeholderFontSize;
/// 最大输入字符长度（支持 XIB）
@property (nonatomic, assign) IBInspectable NSInteger zhh_maxLength;
/// 是否启用密码保护（支持 XIB）
@property (nonatomic, assign) BOOL zhh_securePasswords;
/// 是否显示输入辅助视图（支持 XIB）
@property (nonatomic, assign) BOOL zhh_displayInputAccessoryView;

#pragma mark - 代理
/// 自定义代理，用于监听输入相关事件
@property (nonatomic, weak, nullable) id<UITextFieldHelperDelegate> zhh_delegate;

#pragma mark - 文本范围操作
/**
 *  @brief  获取当前选中的字符串范围
 *
 *  @return 返回当前选中的文本范围（NSRange）
 */
- (NSRange)zhh_selectedRange;

/**
 *  @brief  选中所有文字
 *
 *  @discussion 将当前 `UITextView` 或 `UITextField` 的所有文本设置为选中状态。
 */
- (void)zhh_selectAllText;

/**
 *  @brief  选中指定范围的文字
 *
 *  @param range 要选中的文本范围（NSRange）
 *
 *  @discussion 通过指定范围选中文本，传入的 `NSRange` 可以精确控制选中的文字。
 */
- (void)zhh_setSelectedRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_END
