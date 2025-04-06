//
//  UIViewController+ZHHDismissible.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ZHHDismissible) <UIGestureRecognizerDelegate>

/// 点击视图外部时触发的手势
@property (nonatomic, strong) UITapGestureRecognizer *tapBehindGesture;

/// 视图被关闭后调用，可在子类中重写此方法以执行自定义操作
- (void)viewDismissed:(UIViewController *)presentingVC;

/// 手动调用此方法以关闭当前视图控制器
- (void)dismiss;

@end
