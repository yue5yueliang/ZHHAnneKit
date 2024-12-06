//
//  UIViewController+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用方式
 {
     /// 设置屏幕所支持的方向
     UIInterfaceOrientationMask currentVCInterfaceOrientationMask;
 }
 
 - (void)viewDidLoad{
     [super viewDidLoad];
     // Do any additional setup after loading the view, typically from a nib.
     // 默认所有方向屏
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
 }
 
 // 切换横屏
 - (IBAction)rotationToLandscapeInterface:(id)sender {
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
     [self zhh_swichToNewOrientation:UIInterfaceOrientationLandscapeRight];
 }

 // 切换竖屏
 - (IBAction)rotationToPortraitInterface:(id)sender {
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
     [self zhh_swichToNewOrientation:UIInterfaceOrientationPortrait];
 }

 // 固定横屏
 - (IBAction)lockWithLandscapeInterface:(id)sender {
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskLandscape;
     [self zhh_setNeedsUpdateOfSupportedInterfaceOrientations];
 }

 // 固定竖屏
 - (IBAction)lockWithPortraitInterface:(id)sender {
     // 解除固定横屏或竖屏
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
     // 固定竖屏
     currentVCInterfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
     [self zhh_setNeedsUpdateOfSupportedInterfaceOrientations];
 }
 
 #pragma mark - 实现系统转屏的相关方法即可
 - (BOOL)shouldAutorotate {
     return YES;
 }

 - (UIStatusBarStyle)preferredStatusBarStyle {
     if (@available(iOS 13.0, *)) {
         return UIStatusBarStyleDarkContent;
     } else {
         // Fallback on earlier versions
         return UIStatusBarStyleDefault;
     }
 }

 // 支持哪些屏幕方向
 - (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return currentVCInterfaceOrientationMask;
 }
 */

@interface UIViewController (ZHHCommon)
/**
 尝试将手机旋转为指定方向。请确保传进来的参数属于 -[UIViewController supportedInterfaceOrientations] 返回的范围内，如不在该范围内会旋转失败。
 @return 旋转成功则返回 YES，旋转失败返回 NO。
 @note 请注意与 @c zhh_setNeedsUpdateOfSupportedInterfaceOrientations 的区别：如果你的界面支持N个方向，而你希望保持对这N个方向的支持的情况下把设备方向旋转为这N个方向里的某一个时，应该调用 @c zhh_swichToNewOrientation: 。如果你的界面支持N个方向，而某些情况下你希望把N换成M并触发设备的方向刷新，则请修改方向后，调用 @c zhh_setNeedsUpdateOfSupportedInterfaceOrientations 。
 */
/// 单个界面强制旋转方法1：
/// iOS16 之前进行横竖屏切换方式
/// - Parameter interfaceOrientation: 需要切换的方向
- (BOOL)zhh_swichToNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

/**
 告知系统当前界面的方向有变化，例如解除横屏锁定，需要刷新（注意：Xcode 13上编译iOS 16并不会主动尝试旋转页面）。
 通常在 -[UIViewController supportedInterfaceOrientations] 的值变化后调用。可取代 iOS 16 的同名系统方法。
 */
- (void)zhh_setNeedsUpdateOfSupportedInterfaceOrientations;

@end

@interface UINavigationController (ZHHCommon)

@end


@interface UITabBarController (ZHHCommon)

@end

NS_ASSUME_NONNULL_END
