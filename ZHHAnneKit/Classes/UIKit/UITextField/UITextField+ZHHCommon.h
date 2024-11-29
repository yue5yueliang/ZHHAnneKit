//
//  UITextField+ZHHCommon.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHHTextFieldLeftMaker;

/// 快速设置帐户密码框
@interface UITextField (ZHHCommon)
/// 设置底边框线的颜色
@property (nonatomic, strong) IBInspectable UIColor *bottomLineColor;

/// 设置左视图，类似于帐户密码的标题
- (UIView *)zhh_leftView:(void(^)(ZHHTextFieldLeftMaker * make))withBlock;

/// 设置右侧视图，类似于小圆形叉
/// @param withBlock 单击事件响应
/// @param imageName 图标名称
/// @param width 宽度
/// @param height 高度
/// @param padding 到右侧的距离
- (UIButton *)zhh_rightViewTapBlock:(nullable void(^)(UIButton * button))withBlock
                          imageName:(nullable NSString *)imageName
                              width:(CGFloat)width
                             height:(CGFloat)height
                            padding:(CGFloat)padding;
@end

typedef NS_ENUM(NSInteger, ZHHTextAndImageStyle) {
    /// 图片在左边，文本在右边
    ZHHTextAndImageStyleNormal = 0,
    /// 图片在右边，文本在左边
    ZHHTextAndImageStyleImageRight,
};

/// Related parameter settings of the left view
@interface ZHHTextFieldLeftMaker: NSObject
/// text
@property (nonatomic, strong) NSString *text;
/// Picture name
@property (nonatomic, strong) NSString *imageName;
/// Text color, default control font color
@property (nonatomic, strong) UIColor *textColor;
/// Text font, default control font
@property (nonatomic, strong) UIFont *font;
/// The maximum height of the picture, the default control height is half
@property (nonatomic, assign) CGFloat maxImageHeight;
/// Margin, default 0px
@property (nonatomic, assign) CGFloat periphery;
/// Minimum width, default actual width
@property (nonatomic, assign) CGFloat minWidth;
/// Picture and text style, default picture left and text right
@property (nonatomic, assign) ZHHTextAndImageStyle style;
/// Picture and text spacing, the default is 5px
@property (nonatomic, assign) CGFloat padding;

@end

NS_ASSUME_NONNULL_END
