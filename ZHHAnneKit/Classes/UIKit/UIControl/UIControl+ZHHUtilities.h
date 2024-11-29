//
//  UIControl+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ZHHUtilities)

/// 单击事件延迟间隔时间，设置非零取消间隔
@property(nonatomic)NSTimeInterval zhh_acceptEventInterval;

/// 设置特定事件的音效
/// @param name 音效文件名（必须在主Bundle中）
/// @param controlEvent 触发音效的控制事件
- (void)zhh_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent;
@end

NS_ASSUME_NONNULL_END
