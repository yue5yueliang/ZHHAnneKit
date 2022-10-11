//
//  UIButton+ZHHButtonBlock.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHButtonBlock.h"
#import <objc/runtime.h>

static const void *ZHHUIButtonBlockKey = &ZHHUIButtonBlockKey;

@implementation UIButton (ZHHButtonBlock)

/// 添加点击事件，默认UIControlEventTouchUpInside
- (void)zhh_addActionHandler:(void(^)(UIButton * kButton))touchHandler{
    [self zhh_addActionHandler:touchHandler forControlEvents:UIControlEventTouchUpInside];
}
/// 添加事件
- (void)zhh_addActionHandler:(void(^)(UIButton * kButton))touchHandler forControlEvents:(UIControlEvents)controlEvents{
    objc_setAssociatedObject(self, ZHHUIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(zhh_blockActionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)zhh_blockActionTouched:(UIButton *)sender{
    ZHHTouchedButtonBlock touchHandler = objc_getAssociatedObject(self, ZHHUIButtonBlockKey);
    if (touchHandler) {
        touchHandler(sender);
    }
}
@end
