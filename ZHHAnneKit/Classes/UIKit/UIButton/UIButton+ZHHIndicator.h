//
//  UIButton+ZHHIndicator.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 一个简单的类别，允许您用活动指示器替换按钮的文本.
 */

@interface UIButton (ZHHIndicator)
/// 按钮是否正在提交
@property (nonatomic, assign, readonly) bool submitting;
/// 指示器和文本之间的间隔，默认为5px
@property (nonatomic, assign) CGFloat indicatorSpace;
/// 指示器颜色，默认为白色
@property (nonatomic, assign) UIActivityIndicatorViewStyle indicatorType;

/// 开始提交时，指示符跟随文本
/// @param title prompt text
- (void)zhh_beginSubmitting:(NSString *)title;

/// 提交结束
- (void)zhh_endSubmitting;

/// 此方法将显示活动指示符代替按钮文本。
- (void)zhh_showIndicator;

/// 此方法将删除指示符并将按钮文本放回原位。
- (void)zhh_hideIndicator;
@end

NS_ASSUME_NONNULL_END
