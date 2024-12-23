//
//  ZHHBadgeControl.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZHHBadgeViewFlexMode) {
    ZHHBadgeViewFlexModeHead,    /// 左伸缩 Head Flex    : <==●
    ZHHBadgeViewFlexModeTail,    /// 右伸缩 Tail Flex    : ●==>
    ZHHBadgeViewFlexModeMiddle   /// 左右伸缩 Middle Flex : <=●=>
};

@interface ZHHBadgeControl : UIControl
/// 获取默认的 Badge 实例
+ (instancetype)defaultBadge;

/// 设置文本内容
@property (nullable, nonatomic, copy) NSString *text;

/// 设置富文本内容
@property (nullable, nonatomic, strong) NSAttributedString *attributedText;

/// 设置字体
@property (nonatomic, strong) UIFont *font;

/// 设置背景图片
@property (nullable, nonatomic, strong) UIImage *backgroundImage;

/// Badge 的伸缩方向，默认为 PPBadgeViewFlexModeTail
@property (nonatomic, assign) ZHHBadgeViewFlexMode flexMode;

/// 记录 Badge 的偏移量
@property (nonatomic, assign) CGPoint offset;
@end

NS_ASSUME_NONNULL_END
