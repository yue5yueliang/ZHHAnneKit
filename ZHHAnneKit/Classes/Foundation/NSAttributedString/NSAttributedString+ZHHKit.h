//
//  NSAttributedString+ZHHKit.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/3.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZHHKit)
/**
 固定宽度计算多行文本高度，支持开头空格、自定义插入的文本图片不纳入计算范围，包含emoji表情符仍然会有较大偏差，但在UITextView和UILabel等控件中不影响显示。

 @param width 宽度
 @return size
 */
- (CGSize)zhh_multiLineSize:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
