//
//  UICollectionView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UICollectionView+ZHHUtilities.h"

@implementation UICollectionView (ZHHUtilities)

- (CGRect)zhh_rectForSection:(NSInteger)section {
    // 获取指定节的单元格数量
    NSInteger sectionNum = [self.dataSource collectionView:self numberOfItemsInSection:section];
    if (sectionNum <= 0) {
        return CGRectZero; // 如果该节没有单元格，则返回空区域
    }

    // 获取该节中第一个单元格的区域
    CGRect firstRect = [self zhh_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];

    // 获取该节中最后一个单元格的区域
    CGRect lastRect = [self zhh_rectForRowAtIndexPath:[NSIndexPath indexPathForItem:sectionNum - 1 inSection:section]];

    // 根据布局方向返回该节的矩形区域
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        // 水平滚动布局
        return CGRectMake(CGRectGetMinX(firstRect),
                          0.0f,
                          CGRectGetMaxX(lastRect) - CGRectGetMinX(firstRect),
                          CGRectGetHeight(self.frame));
    } else {
        // 垂直滚动布局
        return CGRectMake(0.0f,
                          CGRectGetMinY(firstRect),
                          CGRectGetWidth(self.frame),
                          CGRectGetMaxY(lastRect) - CGRectGetMinY(firstRect));
    }
}

- (CGRect)zhh_rectForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取指定索引路径的单元格布局属性并返回其区域
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    return attributes ? attributes.frame : CGRectZero;
}

@end
