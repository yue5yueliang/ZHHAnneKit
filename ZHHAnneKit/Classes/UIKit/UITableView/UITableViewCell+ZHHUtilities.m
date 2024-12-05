//
//  UITableViewCell+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITableViewCell+ZHHUtilities.h"

@implementation UITableViewCell (ZHHUtilities)

/// 快速获取或创建表视图单元格的方法
/// @param tableView 需要复用单元格的表视图
/// @return 返回一个复用或新创建的 UITableViewCell
+ (instancetype)zhh_cellWithTableView:(UITableView *)tableView {
    // 从重用队列中获取单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    
    // 如果没有可重用的单元格
    if (!cell) {
        // 检查是否存在对应的 NIB 文件
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"nib"];
        
        if (nibPath.length) {
            // 如果存在 NIB 文件，加载 NIB 文件中的单元格
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] firstObject];
            // 设置复用标识符
            [cell setValue:NSStringFromClass(self.class) forKey:@"reuseIdentifier"];
        } else {
            // 如果不存在 NIB 文件，则以默认样式创建单元格
            cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
        }
    }
    
    return cell;
}
@end
