//
//  UIViewController+ZHHDismissible.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIViewController+ZHHDismissible.h"
#import <objc/runtime.h>

/// 关联对象 Key
static NSString *const kTapBehindGestureKey = @"kTapBehindGestureKey";

@implementation UIViewController (ZHHDismissible)

#pragma mark - 关联属性

/// 设置点击背景手势
- (void)setTapBehindGesture:(UITapGestureRecognizer *)tapBehindGesture {
    objc_setAssociatedObject(self, &kTapBehindGestureKey, tapBehindGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 获取点击背景手势
- (UITapGestureRecognizer *)tapBehindGesture {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kTapBehindGestureKey);
    if (!gesture) {
        // 初始化手势
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedBehind:)];
        gesture.numberOfTapsRequired = 1;
        gesture.cancelsTouchesInView = NO; // 允许手势穿透到视图内部
        gesture.delegate = self;
        [self setTapBehindGesture:gesture];
    }
    return gesture;
}

#pragma mark - 视图关闭相关方法

/// 视图被关闭后调用，子类可重写此方法执行自定义操作
- (void)viewDismissed:(UIViewController *)presentingVC {
    // 这里可以在子类中重写，执行需要的操作
}

/// 关闭当前视图控制器
- (void)dismiss {
    UIViewController *presentingVC = self.presentingViewController;
    [presentingVC dismissViewControllerAnimated:YES completion:^{
        [self viewDismissed:presentingVC];
    }];
}

/// 监听点击背景手势
- (void)touchedBehind:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIView *rootView = self.view.window.rootViewController.view;
        CGPoint location = [sender locationInView:rootView];
        
        // 将触摸点转换到当前视图的坐标系内，如果点击位置在当前视图之外，则关闭视图
        if (![self.view pointInside:[self.view convertPoint:location fromView:rootView] withEvent:nil]) {
            [self dismiss];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

/// 允许多个手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
