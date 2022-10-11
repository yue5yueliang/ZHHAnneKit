//
//  UIView+ZHHCustomBorder.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 视图添加边框
 */

typedef NS_OPTIONS(NSUInteger, ZHHExcludePoint) {
    ZHHExcludeStartPoint = 1 << 0,
    ZHHExcludeEndPoint = 1 << 1,
    ZHHExcludeAllPoint = ~0UL
};

@interface UIView (ZHHCustomBorder)
- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;
- (void)zhh_addLeftBorderWithColor: (UIColor *) color width:(CGFloat)borderWidth;
- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth;

- (void)zhh_removeTopBorder;
- (void)zhh_removeLeftBorder;
- (void)zhh_removeBottomBorder;
- (void)zhh_removeRightBorder;


- (void)zhh_addTopBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge;
- (void)zhh_addLeftBorderWithColor: (UIColor *) color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge;
- (void)zhh_addBottomBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge;
- (void)zhh_addRightBorderWithColor:(UIColor *)color width:(CGFloat)borderWidth excludePoint:(CGFloat)point edgeType:(ZHHExcludePoint)edge;
@end

NS_ASSUME_NONNULL_END
