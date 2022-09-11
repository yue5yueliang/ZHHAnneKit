//
//  UIButton+ContentLayout.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/11.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHButtonContentLayoutStyle) {
    ZHHButtonContentLayoutStyleNormal = 0,       // 内容居中-图左文右
    ZHHButtonContentLayoutStyleCenterImageRight, // 内容居中-图右文左
    ZHHButtonContentLayoutStyleCenterImageTop,   // 内容居中-图上文下
    ZHHButtonContentLayoutStyleCenterImageBottom,// 内容居中-图下文上
    ZHHButtonContentLayoutStyleLeftImageLeft,    // 内容居左-图左文右
    ZHHButtonContentLayoutStyleLeftImageRight,   // 内容居左-图右文左
    ZHHButtonContentLayoutStyleRightImageLeft,   // 内容居右-图左文右
    ZHHButtonContentLayoutStyleRightImageRight,  // 内容居右-图右文左
};
IB_DESIGNABLE
@interface UIButton (ContentLayout)
/// Graphic style
@property (nonatomic, assign) IBInspectable NSInteger layoutType;
/// Picture and text spacing, the default is 0px
@property (nonatomic, assign) IBInspectable CGFloat padding;
/// The spacing between the graphic and text borders, the default is 5px
@property (nonatomic, assign) IBInspectable CGFloat periphery;

/// Set graphics and text mixing, the default border spacing between graphics and text is 5px
/// @param layoutStyle Graphic and text mixed style
/// @param padding Image and text spacing
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding;

/// Set image and text mixing
/// FIXME: There is a problem with this writing that it will break the automatic layout of the button
/// @param layoutStyle Graphic and text mixed style
/// @param padding Image and text spacing
/// @param periphery The distance between the graphic borders
- (void)zhh_contentLayout:(ZHHButtonContentLayoutStyle)layoutStyle padding:(CGFloat)padding periphery:(CGFloat)periphery;
@end

NS_ASSUME_NONNULL_END
