//
//  ZHHNonHoveringHeaderView.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHNonHoveringHeaderView.h"
#import "UITableViewHeaderFooterView+ZHHUtilities.h"

@implementation ZHHNonHoveringHeaderView

- (void)setFrame:(CGRect)frame {
    [super setFrame:[self.zhh_tableView rectForHeaderInSection:self.zhh_section]];
}

@end
