//
//  UITableView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZHHUtilities)
/// 执行一系列方法调用，插入、删除或选择行并接收器的部分。
- (void)zhh_updateWithBlock:(void (^)(UITableView *tableView))block;

/// 滚动接收器，直到屏幕上的一行或一段位置。
- (void)zhh_scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/// 在接收器中插入一行，并带有设置插入动画的选项。
- (void)zhh_insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 使用特定的动画效果重新加载指定的行
- (void)zhh_reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 删除行，并使用一个选项来动画删除
- (void)zhh_deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 将行插入接收器中由indexPath标识的位置，使用一个选项来动画插入
- (void)zhh_insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/// 使用特定的动画效果重新加载指定的行
- (void)zhh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/// 删除由索引路径数组指定的行，使用一个选项来动画删除
- (void)zhh_deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

/// 在接收器中插入一个片段，并使用一个选项使插入动画化
- (void)zhh_insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 删除接收器中的一个部分，带有一个动画删除的选项
- (void)zhh_deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 使用给定的动画效果重新加载指定的section
- (void)zhh_reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/// 取消选择tableView中的所有行。
/// @param animated "是"表示动画转换，"否"表示即时转换。
- (void)zhh_clearSelectedRowsAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
