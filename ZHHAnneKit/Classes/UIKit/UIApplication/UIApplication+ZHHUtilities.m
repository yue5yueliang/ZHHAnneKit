//
//  UIApplication+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIApplication+ZHHUtilities.h"
#define QMUISynthesizeBOOLProperty(_getterName, _setterName) _QMUISynthesizeNonObject(_getterName, _setterName, BOOL, numberWithBool, boolValue)

static CGRect _zhh_keyboardFrame = (CGRect){ (CGPoint){ 0.0f, 0.0f }, (CGSize){ 0.0f, 0.0f } };

@implementation UIApplication (ZHHUtilities)

/// 获取当前键盘的 frame
- (CGRect)zhh_keyboardFrame {
    @synchronized(self) {
        return _zhh_keyboardFrame;
    }
}

/// 加载类时监听键盘事件
+ (void)load {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(zhh_keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(zhh_keyboardDidChangeFrame:)
                                               name:UIKeyboardDidChangeFrameNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(zhh_keyboardDidHide:)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
}

/// 键盘显示通知处理
+ (void)zhh_keyboardDidShow:(NSNotification *)notification {
    @synchronized(self) {
        _zhh_keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }
}

/// 键盘 Frame 变化通知处理
+ (void)zhh_keyboardDidChangeFrame:(NSNotification *)notification {
    @synchronized(self) {
        _zhh_keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    }
}

/// 键盘隐藏通知处理
+ (void)zhh_keyboardDidHide:(NSNotification *)notification {
    @synchronized(self) {
        _zhh_keyboardFrame = CGRectZero;
    }
}

/**
 获取当前活动的窗口

 @return 当前活动的 `UIWindow` 对象
 @discussion 该方法适用于最低支持 iOS 13 的应用，使用 `UIScene` 获取当前 `UIWindowScene` 的窗口。
 */
+ (UIWindow *)zhh_currentWindow {
    // 获取所有连接的场景
    NSArray<UIWindowScene *> *scenes = (NSArray<UIWindowScene *> *)[[[UIApplication sharedApplication] connectedScenes] allObjects];
    
    // 遍历场景，找到 `UIWindowScene` 对象
    for (UIWindowScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
            // 使用 KVC 获取 `window`，以支持 SDK 开发中无法引入宿主 App 的 SceneDelegate 的情况
            UIWindow *window = [scene valueForKeyPath:@"delegate.window"];
            if (window) {
                return window;
            }
        }
    }
    
    // 如果未找到前台活跃场景，返回应用窗口数组的最后一个窗口
    return [UIApplication sharedApplication].windows.lastObject;
}
@end
