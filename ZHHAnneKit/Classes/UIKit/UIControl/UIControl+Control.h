//
//  UIControl+Control.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/9/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Control)
/// Click the event interval, set a non-zero cancellation interval
/// 单击事件延迟间隔时间，设置非零取消间隔
@property(nonatomic)NSTimeInterval zhh_acceptEventInterval;
@end

NS_ASSUME_NONNULL_END
