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
    // 参数验证
    if (!block) {
        NSLog(@"ZHHAnneKit 警告: 点击手势回调块不能为空");
        return;
    }
    
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
    // 参数验证
    if (!block) {
        NSLog(@"ZHHAnneKit 警告: 长按手势回调块不能为空");
        return;
    }
    
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

#pragma mark - 移除手势

/// 移除点击手势
- (void)zhh_removeTapAction {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerTapGestureKey);
    if (gesture) {
        [self removeGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerTapGestureKey, nil, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, &zhh_kActionHandlerTapBlockKey, nil, OBJC_ASSOCIATION_COPY);
    }
}

/// 移除长按手势
- (void)zhh_removeLongPressAction {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey);
    if (gesture) {
        [self removeGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey, nil, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressBlockKey, nil, OBJC_ASSOCIATION_COPY);
    }
}

@end

@implementation UIView (LoadingIndicator)
static char kMaskViewKey;
static char kLoadingIndicatorKey;

// 默认显示加载指示器
- (void)zhh_showLoadingIndicator {
    [self zhh_showLoadingIndicatorWithAlpha:0.8 indicatorStyle:UIActivityIndicatorViewStyleMedium color:nil];
}

// 带有参数的加载指示器
- (void)zhh_showLoadingIndicatorWithAlpha:(CGFloat)alpha indicatorStyle:(UIActivityIndicatorViewStyle)style color:(UIColor * _Nullable)color {
    // 参数验证
    if (alpha < 0.0 || alpha > 1.0) {
        NSLog(@"ZHHAnneKit 警告: 透明度值必须在 0.0 到 1.0 之间");
        alpha = 0.8; // 使用默认值
    }
    
    // 检查是否已存在蒙层
    UIView *maskView = objc_getAssociatedObject(self, &kMaskViewKey);
    
    if (!maskView) {
        // 创建蒙层视图
        maskView = [[UIView alloc] init];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
        maskView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 添加到当前视图
        [self addSubview:maskView];
        
        // 约束蒙层覆盖整个父视图
        [NSLayoutConstraint activateConstraints:@[
            [maskView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [maskView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [maskView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [maskView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        ]];
        
        // 保存蒙层视图
        objc_setAssociatedObject(self, &kMaskViewKey, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 检查是否已存在加载指示器
    UIActivityIndicatorView *loadingIndicator = objc_getAssociatedObject(self, &kLoadingIndicatorKey);
    
    if (!loadingIndicator) {
        // 创建加载指示器（iOS 13.0+）
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        loadingIndicator.hidesWhenStopped = YES;
        loadingIndicator.color = color ?: [UIColor whiteColor]; // 默认白色
        
        // 添加加载指示器到蒙层
        [maskView addSubview:loadingIndicator];
        
        // 设置加载指示器居中
        [NSLayoutConstraint activateConstraints:@[
            [loadingIndicator.centerXAnchor constraintEqualToAnchor:maskView.centerXAnchor],
            [loadingIndicator.centerYAnchor constraintEqualToAnchor:maskView.centerYAnchor]
        ]];
        
        // 保存加载指示器
        objc_setAssociatedObject(self, &kLoadingIndicatorKey, loadingIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 开始动画
    [loadingIndicator startAnimating];
}

// 隐藏蒙层和加载指示器
- (void)zhh_hiddenLoadingIndicator {
    // 获取蒙层视图和加载指示器
    UIView *maskView = objc_getAssociatedObject(self, &kMaskViewKey);
    UIActivityIndicatorView *loadingIndicator = objc_getAssociatedObject(self, &kLoadingIndicatorKey);
    
    // 停止并移除加载指示器
    if (loadingIndicator) {
        [loadingIndicator stopAnimating];
        [loadingIndicator removeFromSuperview];
        objc_setAssociatedObject(self, &kLoadingIndicatorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // 移除蒙层视图
    if (maskView) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [maskView removeFromSuperview];
            objc_setAssociatedObject(self, &kMaskViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }];
    }
}

@end

