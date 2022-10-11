//
//  UIButton+ZHHButtonBlock.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ZHHTouchedButtonBlock)(UIButton * kButton);

IB_DESIGNABLE
@interface UIButton (ZHHButtonBlock)
/// Add click event, default UIControlEventTouchUpInside
/// 添加点击事件，默认 UIControlEventTouchUpInside
- (void)zhh_addActionHandler:(void(^)(UIButton * kButton))block;

/// Add event, does not support multiple enumeration forms
/// 添加事件，不支持多个枚举表单
- (void)zhh_addActionHandler:(void(^)(UIButton * kButton))block forControlEvents:(UIControlEvents)controlEvents;
@end

NS_ASSUME_NONNULL_END
