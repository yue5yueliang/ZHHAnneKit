//
//  UITextField+ZHHSelect.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (ZHHSelect)
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
@end

NS_ASSUME_NONNULL_END
