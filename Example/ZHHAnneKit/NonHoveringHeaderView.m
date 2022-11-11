//
//  NonHoveringHeaderView.m
//  HeaderDemo
//
//  Created by zyd on 2018/6/22.
//  Copyright © 2018年 zyd. All rights reserved.
//

#import "NonHoveringHeaderView.h"
#import <ZHHAnneKit/ZHHAnneKit.h>

@implementation NonHoveringHeaderView

- (void)setFrame:(CGRect)frame {
    [super setFrame:[self.zhh_tableView rectForHeaderInSection:self.zhh_section]];
}

@end
