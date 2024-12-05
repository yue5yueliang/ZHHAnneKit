//
//  UICollectionView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (ZHHUtilities)

/// 获取指定节（section）的区域
/// @param section 节的索引
/// @return 包含该节所有单元格的矩形区域
- (CGRect)zhh_rectForSection:(NSInteger)section;

/// 获取指定单元格（cell）的区域
/// @param indexPath 单元格的索引路径
/// @return 单元格的矩形区域
- (CGRect)zhh_rectForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

