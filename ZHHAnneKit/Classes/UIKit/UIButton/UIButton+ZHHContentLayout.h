//
//  UIButton+ZHHContentLayout.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/11.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图文混排布局样式
typedef NS_ENUM(NSInteger, ZHHButtonContentLayoutStyle) {
    ZHHButtonContentLayoutStyleNone,                ///< 图左文右，居中显示默认
    ZHHButtonContentLayoutStyleCenterImageLeft,     ///< 图右文左，居中显示
    ZHHButtonContentLayoutStyleCenterImageRight,    ///< 图右文左，居中显示
    ZHHButtonContentLayoutStyleCenterImageTop,      ///< 图上文下，居中显示
    ZHHButtonContentLayoutStyleCenterImageBottom,   ///< 图下文上，居中显示
    ZHHButtonContentLayoutStyleLeftImageLeft,       ///< 图左文右，整体靠左
    ZHHButtonContentLayoutStyleLeftImageRight,      ///< 文左图右，整体靠左
    ZHHButtonContentLayoutStyleRightImageLeft,      ///< 图左文右，整体靠右
    ZHHButtonContentLayoutStyleRightImageRight      ///< 文左图右，整体靠右
};


IB_DESIGNABLE
@interface UIButton (ZHHContentLayout)

/// 图文布局类型
@property (nonatomic, assign) ZHHButtonContentLayoutStyle zhh_layoutType;
/// 图文间距
@property (nonatomic, assign) CGFloat zhh_padding;
/// 图文边界间距
@property (nonatomic, assign) CGFloat zhh_periphery;

/// 设置按钮的图文混排布局
/// @param layoutStyle 图文混排样式
/// @param padding 图文间距
/// @param periphery 图文边界间距
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding periphery:(CGFloat)periphery;

/// 设置按钮的图文混排布局（带默认边界间距）
/// @param layoutStyle 图文混排样式
/// @param padding 图文间距
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding;

@end

NS_ASSUME_NONNULL_END
