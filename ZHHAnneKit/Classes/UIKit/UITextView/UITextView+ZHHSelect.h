//
//  UITextView+ZHHSelect.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZHHSelect)
/**
 *  @brief  当前选中的字符串范围
 *
 *  @return NSRange
 */
- (NSRange)zhh_selectedRange;

/**
 *  @brief  选中所有文字
 */
- (void)zhh_selectAllText;

/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围
 */
- (void)zhh_setSelectedRange:(NSRange)range;


//https://github.com/pclion/TextViewCalculateLength
// 用于计算textview输入情况下的字符数，解决实现限制字符数时，计算不准的问题
- (NSInteger)zhh_getInputLengthWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
