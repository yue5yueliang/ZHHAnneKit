//
//  UITableViewHeaderFooterView+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITableViewHeaderFooterView+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation UITableViewHeaderFooterView (ZHHUtilities)

/// 设置 UITableView 的关联属性
/// 通过关联对象将 UITableView 和 UITableViewHeaderFooterView 关联起来
/// @param zhh_tableView 关联的 UITableView
- (void)setZhh_tableView:(UITableView *)zhh_tableView {
    // 使用 objc_setAssociatedObject 来保存关联对象
    // OBJC_ASSOCIATION_RETAIN_NONATOMIC 确保 zhh_tableView 会在 UITableViewHeaderFooterView 存在期间保持引用
    objc_setAssociatedObject(self, @selector(zhh_tableView), zhh_tableView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/// 获取 UITableView 的关联属性
/// @return 返回与 UITableViewHeaderFooterView 关联的 UITableView
- (UITableView *)zhh_tableView {
    // 使用 objc_getAssociatedObject 来获取关联的 UITableView 对象
    return objc_getAssociatedObject(self, _cmd);
}

/// 设置 UITableViewHeaderFooterView 所在的 section 的索引
/// 通过关联对象将 section 索引与 UITableViewHeaderFooterView 关联
/// @param zhh_section 所在的 section 索引
- (void)setZhh_section:(NSUInteger)zhh_section {
    // 使用 objc_setAssociatedObject 保存 section 索引
    // OBJC_ASSOCIATION_ASSIGN 不需要保留该值，只是简单的引用
    objc_setAssociatedObject(self, @selector(zhh_section), @(zhh_section), OBJC_ASSOCIATION_ASSIGN);
}

/// 获取 UITableViewHeaderFooterView 所在的 section 的索引
/// @return 返回 UITableViewHeaderFooterView 所在的 section 索引
- (NSUInteger)zhh_section {
    // 使用 objc_getAssociatedObject 获取与该 view 关联的 section 索引
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

@end
