//
//  UIView+ZHHFind.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZHHFind)
/**
 *  @brief  找到指定类名的SubView对象
 *
 *  @param clazz SubView类名
 *
 *  @return view对象
 */
- (id)zhh_findSubViewWithSubViewClass:(Class)clazz;
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)zhh_findSuperViewWithSuperViewClass:(Class)clazz;

/**
 *  @brief  找到并且释放第一响应者
 *
 *  @return 结果
 */
- (BOOL)zhh_findAndResignFirstResponder;
/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)zhh_findFirstResponder;

/**
 *  @brief  找到当前view所在的viewcontroler
 */
@property (readonly) UIViewController *zhh_viewController;

/**
 * @brief 找到当前view所在的navigationController
 */
@property (readonly) UINavigationController *zhh_navigationController;

/**
 * @brief 找到当前view所在的tabBarController
 */
@property (readonly) UITabBarController *zhh_tabBarController;
@end

NS_ASSUME_NONNULL_END
