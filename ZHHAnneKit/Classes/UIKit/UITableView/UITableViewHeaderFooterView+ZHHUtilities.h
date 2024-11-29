//
//  UITableViewHeaderFooterView+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewHeaderFooterView (ZHHUtilities)
/// 关联的 UITableView 实例
@property (nonatomic, weak) UITableView *zhh_tableView;
/// 关联的 section 索引
@property (nonatomic, assign) NSUInteger zhh_section;
@end

NS_ASSUME_NONNULL_END
