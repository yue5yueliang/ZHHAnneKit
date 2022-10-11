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
 @method
 @abstract 针对label或view 添加tap手势
 @param block 代码块
 */
- (void)zhh_addTapActionWithBlock:(ZHHGestureActionBlock)block;
/**
 *  @brief  针对label或view 添加长按手势
 *
 *  @param block 代码块
 */
- (void)zhh_addLongPressActionWithBlock:(ZHHGestureActionBlock)block;
@end

NS_ASSUME_NONNULL_END

