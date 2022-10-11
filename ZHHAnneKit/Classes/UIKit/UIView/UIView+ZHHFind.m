//
//  UIView+ZHHFind.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHFind.h"

@implementation UIView (ZHHFind)
/**
 *  @brief  找到指定类名的view对象
 *
 *  @param clazz view类名
 *
 *  @return view对象
 */
- (id)zhh_findSubViewWithSubViewClass:(Class)clazz{
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return subView;
        }
    }
    return nil;
}

/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)zhh_findSuperViewWithSuperViewClass:(Class)clazz {
    if (self == nil) {
        return nil;
    } else if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    } else {
        return [self.superview zhh_findSuperViewWithSuperViewClass:clazz];
    }
}

/**
 *  @brief  找到并且resign第一响应者
 *
 *  @return 结果
 */
- (BOOL)zhh_findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *v in self.subviews) {
        if ([v zhh_findAndResignFirstResponder]) {
            return YES;
        }
    }
    return NO;
}

/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)zhh_findFirstResponder {
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
        && (self.isFirstResponder)) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *fv = [v zhh_findFirstResponder];
        if (fv) {
            return fv;
        }
    }
    
    return nil;
}

/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *)zhh_viewController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}

/**
 * @brief 找到当前view所在的navigationController
 */
- (UINavigationController *)zhh_navigationController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)responder;
        }
        
        responder = responder.nextResponder;
    } while (responder);
    
    return nil;
}

/**
 * @brief 找到当前view所在的tabBarController
 */
- (UITabBarController *)zhh_tabBarController {
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)responder;
        }
        
        responder = responder.nextResponder;
    } while (responder);
    
    return nil;
}
@end
