//
//  UIView+ZHHBlockGesture.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZHHGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);
@interface UIView (ZHHBlockGesture)
/*!
 @method zhh_addTapActionWithBlock:
 @abstract 为 UILabel 或 UIView 添加点击手势。
 @discussion 通过此方法可以为 UILabel 或 UIView 添加点击手势，并在回调中处理点击事件。
 @param block 手势触发时的回调代码块。
 */
- (void)zhh_addTapActionWithBlock:(ZHHGestureActionBlock)block;

/*!
 @method zhh_addLongPressActionWithBlock:
 @abstract 为 UILabel 或 UIView 添加长按手势。
 @discussion 通过此方法可以为 UILabel 或 UIView 添加长按手势，并在回调中处理长按事件。
 @param block 手势触发时的回调代码块。
 */
- (void)zhh_addLongPressActionWithBlock:(ZHHGestureActionBlock)block;

/*!
 @method zhh_removeTapAction
 @abstract 移除点击手势。
 @discussion 移除通过 zhh_addTapActionWithBlock: 添加的点击手势。
 */
- (void)zhh_removeTapAction;

/*!
 @method zhh_removeLongPressAction
 @abstract 移除长按手势。
 @discussion 移除通过 zhh_addLongPressActionWithBlock: 添加的长按手势。
 */
- (void)zhh_removeLongPressAction;

@end


@interface UIView (LoadingIndicator)
// 显示默认的蒙层和加载指示器（带默认参数）
- (void)zhh_showLoadingIndicator;

// 显示带自定义配置的蒙层和加载指示器
// @param alpha 蒙层的透明度
// @param style 指示器的样式
// @param color 指示器的颜色（可为空，默认为白色）
- (void)zhh_showLoadingIndicatorWithAlpha:(CGFloat)alpha indicatorStyle:(UIActivityIndicatorViewStyle)style color:(UIColor * _Nullable)color;

// 隐藏蒙层和加载指示器
- (void)zhh_hiddenLoadingIndicator;

@end
NS_ASSUME_NONNULL_END

