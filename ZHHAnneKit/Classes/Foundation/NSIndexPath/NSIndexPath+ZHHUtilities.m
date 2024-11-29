//
//  NSIndexPath+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSIndexPath+ZHHUtilities.h"

@implementation NSIndexPath (ZHHUtilities)
/**
 *  @brief  获取当前 section 的前一行
 *
 *  @discussion 适用于 UITableView 或其他使用行数（row）的场景。
 *  若当前 row 为 0，则返回 nil。
 *
 *  @return 返回前一行的 NSIndexPath，如果已是第一行则返回 nil
 */
- (NSIndexPath *)zhh_previousRow {
    if (self.row > 0) {
        return [NSIndexPath indexPathForRow:self.row - 1 inSection:self.section];
    }
    return nil; // 无法获取前一行
}

/**
 *  @brief  获取当前 section 的下一行
 *
 *  @discussion 适用于 UITableView 或其他使用行数（row）的场景。
 *
 *  @return 返回下一行的 NSIndexPath
 */
- (NSIndexPath *)zhh_nextRow {
    return [NSIndexPath indexPathForRow:self.row + 1 inSection:self.section];
}

/**
 *  @brief  获取当前 section 的前一项（适用于 UICollectionView）
 *
 *  @discussion 若当前 item 为 0，则返回 nil。
 *
 *  @return 返回前一项的 NSIndexPath，如果已是第一项则返回 nil
 */
- (NSIndexPath *)zhh_previousItem {
    if (self.item > 0) {
        return [NSIndexPath indexPathForItem:self.item - 1 inSection:self.section];
    }
    return nil; // 无法获取前一项
}

/**
 *  @brief  获取当前 section 的下一项（适用于 UICollectionView）
 *
 *  @discussion 用于 UICollectionView 中基于 item 的场景。
 *
 *  @return 返回下一项的 NSIndexPath
 */
- (NSIndexPath *)zhh_nextItem {
    return [NSIndexPath indexPathForItem:self.item + 1 inSection:self.section];
}

/**
 *  @brief  获取当前行的下一 section
 *
 *  @discussion 当前行数（row）保持不变，section +1。
 *  注意：需根据实际数据源范围控制 section 的上限。
 *
 *  @return 返回下一 section 的 NSIndexPath
 */
- (NSIndexPath *)zhh_nextSection {
    return [NSIndexPath indexPathForRow:self.row inSection:self.section + 1];
}

/**
 *  @brief  获取当前行的上一 section
 *
 *  @discussion 当前行数（row）保持不变，section -1。
 *  若当前 section 为 0，则返回 nil。
 *
 *  @return 返回上一 section 的 NSIndexPath，如果已是第一个 section 则返回 nil
 */
- (NSIndexPath *)zhh_previousSection {
    if (self.section > 0) {
        return [NSIndexPath indexPathForRow:self.row inSection:self.section - 1];
    }
    return nil; // 无法获取上一 section
}
@end
