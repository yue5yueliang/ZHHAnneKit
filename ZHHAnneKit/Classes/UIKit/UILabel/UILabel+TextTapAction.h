//
//  UILabel+TextTapAction.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZHHLabelTapBlock)(UILabel * label, NSString * string, NSRange range, NSInteger index);

@interface UILabel (TextTapAction)
/// 是否打开单击，默认为是
@property (nonatomic, assign) BOOL zhh_openTap;
/// 单击高光颜色，默认为红色
@property (nonatomic, strong) UIColor *zhh_highlightColor;
/// 是否扩展单击范围，默认为“是”
@property (nonatomic, assign) BOOL zhh_enlargeTapArea;

/// 将单击事件添加到文本中
/// @param strings The string array that needs to be added
/// @param withBlock click event callback
- (void)zhh_addAttributeTapActionWithStrings:(NSArray<NSString *> *)strings withBlock:(ZHHLabelTapBlock)withBlock;

/// 根据范围向文本中添加单击事件
/// @param ranges The Range string array that needs to be added
/// @param withBlock click event callback
- (void)zhh_addAttributeTapActionWithRanges:(NSArray<NSString *> *)ranges withBlock:(ZHHLabelTapBlock)withBlock;

/// 删除单击事件
- (void)zhh_removeAttributeTapActions;
@end

NS_ASSUME_NONNULL_END
