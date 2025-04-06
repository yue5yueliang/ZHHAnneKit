//
//  UINavigationBar+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2020/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 阴影类型枚举，提供预设的几种阴影效果
typedef NS_ENUM(NSUInteger, ZHHNavigationBarShadowType) {
    ZHHNavigationBarShadowTypeLight,   ///< 轻微阴影，适用于较为柔和的界面效果
    ZHHNavigationBarShadowTypeMedium,  ///< 强烈阴影，适用于需要强烈视觉对比的效果
    ZHHNavigationBarShadowTypeHeavy    ///< 自定义阴影，开发者可以完全自定义阴影的颜色、偏移、透明度等参数
};

@interface UINavigationBar (ZHHUtilities)
@property (nonatomic, assign) BOOL zhh_enableScrollEdgeAppearance; ///< 导航外观是否根据滚动边缘变化 默认 YES
@property (nonatomic, assign) BOOL zhh_translucent; ///< 是否半透明 默认 YES
@property (nonatomic, assign) BOOL zhh_transparent; ///< 是否全透明
@property (nonatomic, assign) BOOL zhh_hideBottomLine; ///< 是否隐藏底部线条
@property (nonatomic, strong) UIFont *zhh_titleFont; ///< 设置标题字体大小
@property (nonatomic, strong) UIColor *zhh_titleColor; ///< 设置标题字体颜色
@property (nonatomic, strong) UIColor *zhh_backgroundColor; ///< 导航栏背景颜色
@property (nonatomic, strong) UIColor *zhh_tintColor; ///< 导航栏主题色

/// 重置导航栏的所有配置到默认值，恢复初始状态。
/// 调用此方法会重置导航栏的所有自定义设置，例如颜色、字体、透明度等，恢复为默认值。
- (void)zhh_resetConfiguration;

/// 修改配置后，需要调用此方法来应用修改的设置，更新导航栏的外观。
/// 调用此方法会根据当前的配置更新导航栏的外观（例如颜色、字体等）。
/// 需要在修改导航栏配置之后调用，才能生效。
- (void)zhh_configuration;

/// 使用回调 block 进行自定义导航栏配置。
/// 通过该方法，开发者可以传入一个 block 来对导航栏进行个性化配置，
/// 例如设置标题字体、颜色、背景色等。配置完成后，调用 `zhh_configuration` 方法来应用设置。
/// @param configurationBlock 自定义配置的 block，可以修改导航栏的各种属性。
- (void)zhh_configureWithBlock:(void (^)(UINavigationBar *bar))configurationBlock;

/// 根据阴影类型应用预设阴影效果。
///
/// @param shadowType 阴影类型，使用 `ZHHNavigationBarShadowType` 枚举来指定阴影效果。
- (void)zhh_navigationBarShadowWithType:(ZHHNavigationBarShadowType)shadowType;

/// 应用轻微阴影效果。阴影偏移为2，透明度为0.25，半径为4.0。
///
/// @param shadowOffset 阴影偏移量，控制阴影的垂直位置。
/// @param shadowOpacity 阴影透明度，0为完全透明，1为完全不透明。
/// @param shadowRadius 阴影的模糊半径，影响阴影的扩散范围。
- (void)zhh_navigationBarCustomShadowOffset:(CGFloat)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;

/// 自定义阴影设置，允许开发者根据需要设置阴影的颜色、偏移量、透明度和半径。
///
/// @param shadowColor 阴影颜色。
/// @param shadowOffset 阴影偏移量，控制阴影的垂直位置。
/// @param shadowOpacity 阴影透明度，0为完全透明，1为完全不透明。
/// @param shadowRadius 阴影的模糊半径，影响阴影的扩散范围。
- (void)zhh_navigationBarCustomShadowColor:(UIColor *)shadowColor shadowOffset:(CGFloat)shadowOffset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius;

@end

NS_ASSUME_NONNULL_END
