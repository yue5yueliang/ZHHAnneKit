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
    [self addSubview:self.customView];
    self.customView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [super setFrame:[self.zhh_tableView rectForHeaderInSection:self.zhh_section]];
}

- (UIView *)customView {
    if (!_customView) {
        _customView = [[UIView alloc] init];
    }
    return _customView;
}
@end
