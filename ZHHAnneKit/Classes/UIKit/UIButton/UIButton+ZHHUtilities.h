//
//  UIButton+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHUtilities)
#pragma mark --- 按钮图片及背景
/// @brief  使用颜色设置按钮背景
/// @param backgroundColor 背景颜色
/// @param state           按钮状态
- (void)zhh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/// 设置按钮的图片，通过 URL 异步加载图片并设置
/// @param imageURL 图片的 URL 地址
- (void)zhh_setImageWithURL:(NSString *)imageURL;

#pragma mark --- 倒计时相关
/// 倒计时期间背景色
@property (nonatomic, strong) UIColor *zhh_disabledBackgroundColor;
/// 开始验证码倒计时（默认倒计时时间为 60 秒）
- (void)zhh_startCountdown;
/// 开始验证码倒计时
/// @param timeout 倒计时时间，单位秒（如 60 秒）
/// @param resendText 倒计时结束时显示的文本（如 "重新获取"）
/// @param countdownText 倒计时过程中显示的文本模板，使用 @"%@" 作为秒数占位符（如 @"%@秒后获取"）
- (void)zhh_startCountdownWithTimeout:(NSInteger)timeout resendText:(NSString *)resendText countdownText:(NSString *)countdownText;
@end

NS_ASSUME_NONNULL_END
