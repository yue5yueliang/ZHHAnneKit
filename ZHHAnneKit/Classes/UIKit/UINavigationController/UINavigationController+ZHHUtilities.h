//
//  UINavigationController+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZHHUtilities)

/**
 *  推送一个新的 ViewController，并带有自定义动画。
 *
 *  @param controller 需要推送的 ViewController。
 *  @param type 动画类型（可传入 `kCATransitionFade`, `kCATransitionPush`, `kCATransitionMoveIn`, `kCATransitionReveal` 等）。
 *  @param subtype 动画方向（可传入 `kCATransitionFromRight`, `kCATransitionFromLeft`, `kCATransitionFromTop`, `kCATransitionFromBottom` 等）。
 */
- (void)zhh_pushViewController:(UIViewController *)controller withTransitionType:(CATransitionType)type subtype:(CATransitionSubtype)subtype;

/**
 *  弹出当前 ViewController，并带有自定义动画。
 *
 *  @param type 动画类型（可传入 `kCATransitionFade`, `kCATransitionPush`, `kCATransitionMoveIn`, `kCATransitionReveal` 等）。
 *  @param subtype 动画方向（可传入 `kCATransitionFromRight`, `kCATransitionFromLeft`, `kCATransitionFromTop`, `kCATransitionFromBottom` 等）。
 *
 *  @return 弹出的 ViewController。
 */
- (UIViewController *)zhh_popViewController:(CATransitionType)type subtype:(CATransitionSubtype)subtype;

/**
 * @brief 在导航栈中查找指定类型的 ViewController 对象。
 *
 * @param className ViewController 的类名。
 *
 * @return 返回找到的 ViewController 对象，如果未找到则返回 nil。
 */
- (UIViewController * _Nullable)zhh_findViewControllerWithClassName:(NSString * _Nonnull)className;
/**
 * @brief 判断当前导航控制器是否仅包含一个 RootViewController。
 *
 * @return 如果导航控制器仅包含一个 RootViewController，返回 YES；否则返回 NO。
 */
- (BOOL)zhh_isOnlyContainRootViewController;
/**
 * @brief 获取当前导航控制器的根视图控制器（RootViewController）。
 *
 * @return 返回根视图控制器对象；如果没有任何视图控制器，返回 nil。
 */
- (UIViewController *)zhh_rootViewController;
/**
 * @brief 返回到导航堆栈中指定类名的视图控制器。
 *
 * @param className 指定的视图控制器类名。
 * @param animated  是否启用动画。
 *
 * @return 从导航堆栈中弹出的视图控制器数组。如果未找到指定的视图控制器，返回 nil。
 */
- (NSArray<UIViewController *> *)zhh_popToViewControllerWithClassName:(NSString *)className animated:(BOOL)animated;
/**
 * @brief 从导航堆栈中 pop 出指定层级的视图控制器。
 *
 * @param level    要返回的层级数。例如，level=1 表示返回到当前控制器的上一层。
 * @param animated 是否启用动画。
 *
 * @return 从导航堆栈中弹出的视图控制器数组。如果层级数超过堆栈的数量，则返回根视图控制器。
 */
- (NSArray<UIViewController *> *)zhh_popToViewControllerWithLevel:(NSInteger)level animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
