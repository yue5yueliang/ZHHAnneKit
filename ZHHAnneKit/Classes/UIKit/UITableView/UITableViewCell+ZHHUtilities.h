//
//  UITableViewCell+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ZHHUtilities)

/// 快速获取或创建表视图单元格的方法
/// @param tableView 需要复用单元格的表视图
/// @return 返回一个复用或新创建的 UITableViewCell
+ (instancetype)zhh_cellWithTableView:(UITableView *)tableView;

@end
