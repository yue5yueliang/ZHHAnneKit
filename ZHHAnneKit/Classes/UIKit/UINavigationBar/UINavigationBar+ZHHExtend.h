//
//  UINavigationBar+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (ZHHExtend)
/// 设置导航栏的背景色
@property (nonatomic, strong) UIColor *navgationBackground;
/// 设置图片背景导航栏
@property (nonatomic, strong) UIImage *navgationImage;
/// 设置自定义后退按钮
@property (nonatomic, strong) NSString *navgationCustomBackImageName;
/// 系统导航栏分界线
@property (nonatomic, strong, readonly) UIImageView *navgationBarBottomLine;
/// 设置导航栏标题的颜色和字体大小
@property (nonatomic, copy, readonly) UINavigationBar * (^kChangeNavigationBarTitle)(UIColor *, UIFont *);

/// 设置导航栏的标题颜色和字体大小，与Swift兼容，易于使用
/// @param color Navigation 栏标题颜色
/// @param font 导航栏标题的字体大小
- (instancetype)zhh_setNavigationBarTitleColor:(UIColor *)color font:(UIFont *)font;
/// 隐藏导航栏底部的下划线
- (UINavigationBar *)zhh_hiddenNavigationBarBottomLine;
/// 默认情况下恢复为系统颜色和下划线
- (void)zhh_resetNavigationBarSystem;

//************************ 自定义导航栏相关 ***********************

/// 更改导航栏
/// @param image 导航栏图片
/// @param color 导航栏背景色
- (instancetype)zhh_customNavgationBackImage:(UIImage *_Nullable)image background:(UIColor *_Nullable)color;

/// 改变透明度
- (instancetype)zhh_customNavgationAlpha:(CGFloat)alpha;

/// 导航栏背景的高度,
/// Note: 此处不更改导航栏的高度，但更改了自定义背景的高度
- (instancetype)zhh_customNavgationHeight:(CGFloat)height;

/// 隐藏底线
- (instancetype)zhh_customNavgationHiddenBottomLine:(BOOL)hidden;

/// 更改自定义底线的颜色
- (instancetype)zhh_customNavgationChangeBottomLineColor:(UIColor *)color;
/// 还原回系统导航栏
- (void)zhh_customNavigationRestoreSystemNavigation;
@end

NS_ASSUME_NONNULL_END
