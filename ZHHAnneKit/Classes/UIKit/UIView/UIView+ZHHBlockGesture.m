//
//  UIView+ZHHBlockGesture.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHBlockGesture.h"
#import <objc/runtime.h>

// 定义静态变量用于关联对象的键
static char zhh_kActionHandlerTapBlockKey;
static char zhh_kActionHandlerTapGestureKey;
static char zhh_kActionHandlerLongPressBlockKey;
static char zhh_kActionHandlerLongPressGestureKey;

@implementation UIView (ZHHBlockGesture)

#pragma mark - 添加点击手势

/// 添加点击手势及回调
/// @param block 点击手势回调
- (void)zhh_addTapActionWithBlock:(ZHHGestureActionBlock)block {
    // 获取已有的点击手势
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerTapGestureKey);
    if (!gesture) {
        // 如果没有点击手势，创建并关联
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhh_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    // 将回调块与视图关联
    objc_setAssociatedObject(self, &zhh_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

/// 点击手势的响应方法
/// @param gesture 点击手势
- (void)zhh_handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        // 获取回调块并执行
        ZHHGestureActionBlock block = objc_getAssociatedObject(self, &zhh_kActionHandlerTapBlockKey);
        if (block) {
            block(gesture);
        }
    }
}

#pragma mark - 添加长按手势

/// 添加长按手势及回调
/// @param block 长按手势回调
- (void)zhh_addLongPressActionWithBlock:(ZHHGestureActionBlock)block {
    // 获取已有的长按手势
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey);
    if (!gesture) {
        // 如果没有长按手势，创建并关联
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zhh_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    // 将回调块与视图关联
    objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

/// 长按手势的响应方法
/// @param gesture 长按手势
- (void)zhh_handleActionForLongPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        // 获取回调块并执行
        ZHHGestureActionBlock block = objc_getAssociatedObject(self, &zhh_kActionHandlerLongPressBlockKey);
        if (block) {
            block(gesture);
        }
    }
}

@end
