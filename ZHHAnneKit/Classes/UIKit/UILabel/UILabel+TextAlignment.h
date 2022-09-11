//
//  UILabel+TextAlignment.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZHHLabelTextAlignmentType) {
    ZHHLabelTextAlignmentTypeLeft = 0,
    ZHHLabelTextAlignmentTypeRight,
    ZHHLabelTextAlignmentTypeCenter,
    ZHHLabelTextAlignmentTypeLeftTop,
    ZHHLabelTextAlignmentTypeRightTop,
    ZHHLabelTextAlignmentTypeLeftBottom,
    ZHHLabelTextAlignmentTypeRightBottom,
    ZHHLabelTextAlignmentTypeTopCenter,
    ZHHLabelTextAlignmentTypeBottomCenter,
};

@interface UILabel (TextAlignment)
/// 设置文本内容的显示位置，
/// 无需在外部设置“textAlignment”属性
@property (nonatomic, assign) ZHHLabelTextAlignmentType zhh_customTextAlignment;

/// 可复制
@property (nonatomic, assign) BOOL zhh_copyable;

/// 删除复印长按手势
- (void)zhh_removeCopyLongPressGestureRecognizer;
@end

NS_ASSUME_NONNULL_END
