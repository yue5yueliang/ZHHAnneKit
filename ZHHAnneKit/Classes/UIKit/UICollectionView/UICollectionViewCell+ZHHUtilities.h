//
//  UICollectionViewCell+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (ZHHUtilities)

/// 快速获取或创建集合视图单元格的方法
/// @param collectionView 需要复用单元格的集合视图
/// @return 返回一个复用或新创建的 UICollectionViewCell
+ (instancetype)zhh_cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
