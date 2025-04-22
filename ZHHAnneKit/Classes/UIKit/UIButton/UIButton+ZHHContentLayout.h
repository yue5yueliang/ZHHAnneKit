//
//  UIButton+ZHHContentLayout.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/11.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 控制图片在UIButton里的位置，默认为ZHHUIButtonImagePositionLeft
typedef NS_ENUM(NSUInteger, ZHHUIButtonImagePosition) {
    ZHHUIButtonImagePositionTop,             ///< imageView在titleLabel上面
    ZHHUIButtonImagePositionLeft,            ///< imageView在titleLabel左边
    ZHHUIButtonImagePositionBottom,          ///< imageView在titleLabel下面
    ZHHUIButtonImagePositionRight,           ///< imageView在titleLabel右边
};

IB_DESIGNABLE
@interface UIButton (ZHHContentLayout)

/// 设置按钮里图标和文字的相对位置，默认为ZHHUIButtonImagePositionLeft
/// 可配合imageEdgeInsets、titleEdgeInsets、contentHorizontalAlignment、contentVerticalAlignment使用
@property (nonatomic, assign) ZHHUIButtonImagePosition zhh_position;
/// 图文间距
@property (nonatomic, assign) CGFloat zhh_spacing;

/// 设置按钮的图文混排布局
/// @param position 图文混排样式
/// @param spacing 图文间距
- (void)zhh_buttonImagePosition:(ZHHUIButtonImagePosition)position spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
