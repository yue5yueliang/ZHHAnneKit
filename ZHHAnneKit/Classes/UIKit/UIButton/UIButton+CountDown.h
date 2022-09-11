//
//  UIButton+CountDown.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CountDown)
/// 开始倒计时
/// @param timeout 时间间隔
/// @param format 倒计时文案，默认值为@“%zd秒”
- (void)zhh_startTime:(NSInteger)timeout countdownFormat:(nullable NSString *)format;

/// 取消倒计时
- (void)zhh_cancelTimer;

/// 在倒计时结束时回调
- (void)zhh_countDownTimeStop:(void(^)(void))withBlock;
@end

NS_ASSUME_NONNULL_END
