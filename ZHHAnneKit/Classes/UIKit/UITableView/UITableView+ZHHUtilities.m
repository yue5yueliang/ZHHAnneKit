//
//  UITableView+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITableView+ZHHUtilities.h"

@implementation UITableView (ZHHUtilities)
/// 执行一系列更新操作的封装方法，block中进行更新操作
- (void)zhh_updateWithBlock:(void (^)(UITableView *tableView))block {
    [self beginUpdates];
    if (block) {
        block(self);
    }
    [self endUpdates];
}

/// 滚动到指定行并调整位置
- (void)zhh_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

/// 插入一行
- (void)zhh_insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

/// 插入指定位置的行
- (void)zhh_insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self zhh_insertRowAtIndexPath:indexPath withRowAnimation:animation];
}

/// 刷新指定行
- (void)zhh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

/// 刷新指定位置的行
- (void)zhh_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self zhh_reloadRowAtIndexPath:indexPath withRowAnimation:animation];
}

/// 删除指定行
- (void)zhh_deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation {
    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

/// 删除指定位置的行
- (void)zhh_deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [self zhh_deleteRowAtIndexPath:indexPath withRowAnimation:animation];
}

/// 插入一节
- (void)zhh_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self insertSections:sections withRowAnimation:animation];
}

/// 删除指定节
- (void)zhh_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *sections = [NSIndexSet indexSetWithIndex:section];
    [self deleteSections:sections withRowAnimation:animation];
}

/// 刷新指定节
- (void)zhh_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self reloadSections:indexSet withRowAnimation:animation];
}

/// 清除所有选中的行
- (void)zhh_clearSelectedRowsAnimated:(BOOL)animated {
    NSArray *indexPaths = [self indexPathsForSelectedRows];
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *path, NSUInteger idx, BOOL *stop) {
        [self deselectRowAtIndexPath:path animated:animated];
    }];
}

@end
