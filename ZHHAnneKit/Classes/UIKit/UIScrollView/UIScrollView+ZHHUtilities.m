//
//  UINavigationBar+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2020/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIScrollView+ZHHUtilities.h"

@implementation UIScrollView (ZHHUtilities)

/// 获取滚动范围的四个边界，返回一个 UIEdgeInsets 结构体
/// @return 返回滚动范围的上下左右边界
- (UIEdgeInsets)contentOffsetOfRange {
    // 获取当前视图的 bounds 和 contentSize
    CGRect bounds = self.bounds;
    CGSize contentSize = self.contentSize;
    UIEdgeInsets contentInset = self.contentInset;

    // 计算滚动的上下边界
    CGFloat minY = -contentInset.top; // 上边界
    CGFloat maxY = -(bounds.size.height - contentInset.bottom - contentSize.height); // 下边界

    // 计算滚动的左右边界
    CGFloat minX = -contentInset.left; // 左边界
    CGFloat maxX = -(bounds.size.width - contentInset.right - contentSize.width); // 右边界

    // 返回上下左右的滚动范围
    return UIEdgeInsetsMake(minY, minX, maxY, maxX);
}

/// 滚动到内容的底部
/// @param animated 是否使用动画
- (void)zhh_scrollToBottomWithAnimated:(BOOL)animated {
    // 获取滚动范围
    UIEdgeInsets range = [self contentOffsetOfRange];
    
    // 获取底部的滚动偏移
    CGFloat offsetYMax = range.bottom;
    
    // 设置滚动到底部的偏移
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetYMax;
    
    // 根据是否需要动画，滚动到指定位置
    [self setContentOffset:contentOffset animated:animated];
}

/// 滚动到内容的顶部
/// @param animated 是否使用动画
- (void)zhh_scrollToTopWithAnimated:(BOOL)animated {
    // 获取顶部的滚动偏移
    CGFloat offsetYMin = [self contentOffsetOfRange].top;
    
    // 设置滚动到顶部的偏移
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetYMin;
    
    // 根据是否需要动画，滚动到指定位置
    [self setContentOffset:contentOffset animated:animated];
}

/// 滚动到指定的视图
/// @param toView 目标视图
/// @param animated 是否使用动画
- (void)zhh_scrollToView:(UIView *)toView animated:(BOOL)animated {
    // 计算目标视图的起始位置和终止位置
    CGFloat contanceX = MAX(toView.frame.origin.x - self.contentOffset.x, 0);
    CGFloat contanceMaxX = CGRectGetMaxX(toView.frame) - self.bounds.size.width;
    
    // 取最大值，确保目标视图能够完全显示
    contanceX = MIN(contanceX, contanceMaxX);
    
    // 根据是否需要动画，滚动到目标视图的位置
    [self setContentOffset:CGPointMake(contanceX, 0) animated:animated];
}

@end
