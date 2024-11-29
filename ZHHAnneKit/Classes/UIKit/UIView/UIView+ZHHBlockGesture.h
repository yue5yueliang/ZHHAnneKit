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
@end

NS_ASSUME_NONNULL_END

