//
//  UIButton+Indicator.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Indicator)
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

/// 显示指示器
- (void)zhh_showIndicator;

/// 隐藏指示器
- (void)zhh_hideIndicator;
@end

NS_ASSUME_NONNULL_END
