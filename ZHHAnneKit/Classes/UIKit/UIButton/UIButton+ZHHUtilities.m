//
//  UIButton+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHUtilities.h"
#import "UIImage+ZHHColor.h"
#import <objc/runtime.h>

@implementation UIButton (ZHHUtilities)

/// @brief  使用颜色设置按钮背景
/// @param backgroundColor 背景颜色
/// @param state           按钮状态
- (void)zhh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage zhh_imageWithColor:backgroundColor] forState:state];
}

/// 设置按钮的图片，通过 URL 异步加载图片并设置
/// @param imageURL 图片的 URL 地址
- (void)zhh_setImageWithURL:(NSString *)imageURL {
    // 检查 URL 字符串的有效性
    if (!imageURL || ![imageURL isKindOfClass:[NSString class]] || imageURL.length == 0) {
        NSLog(@"图片 URL 无效");
        return;
    }

    NSURL *url = [NSURL URLWithString:imageURL];
    if (!url) {
        NSLog(@"无法从字符串创建有效的 NSURL: %@", imageURL);
        return;
    }

    // 使用全局并发队列来处理图片的异步下载任务
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 下载图片数据
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if (!imageData) {
            NSLog(@"从 URL 加载图片数据失败: %@", url);
            return;
        }

        UIImage *image = [UIImage imageWithData:imageData];
        if (!image) {
            NSLog(@"从图片数据创建 UIImage 失败");
            return;
        }

        // 切回主线程更新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image forState:UIControlStateNormal];
        });
    });
}


/// 关联对象，用于保存按钮的初始背景颜色
- (void)setZhh_disabledBackgroundColor:(UIColor *)zhh_disabledBackgroundColor {
    objc_setAssociatedObject(self, @selector(zhh_disabledBackgroundColor), zhh_disabledBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)zhh_disabledBackgroundColor {
    return objc_getAssociatedObject(self, @selector(zhh_disabledBackgroundColor));
}

/// 开始验证码倒计时，设置默认值
- (void)zhh_startCountdown {
    [self zhh_startCountdownWithTimeout:60 resendText:@"重新获取" countdownText:@"%@ 秒后获取"];
}

/// 倒计时方法
- (void)zhh_startCountdownWithTimeout:(NSInteger)timeout resendText:(NSString *)resendText countdownText:(NSString *)countdownText {
    NSAssert(timeout > 0, @"倒计时时间必须大于 0");
    NSAssert(resendText.length > 0, @"重新获取的文本不能为空");
    NSAssert(countdownText.length > 0, @"倒计时的文本格式不能为空");

    // 保存初始背景颜色
    UIColor *originalBackgroundColor = self.backgroundColor;

    __block NSInteger remainingTime = timeout;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    // 设置定时器，每秒触发一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (remainingTime <= 0) { // 倒计时结束
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 恢复按钮状态
                self.userInteractionEnabled = YES;
                [self setTitle:resendText forState:UIControlStateNormal];
                // 如果设置了倒计时背景色，则恢复背景色
                if (self.zhh_disabledBackgroundColor) {
                    [self zhh_setBackgroundColor:originalBackgroundColor forState:UIControlStateNormal];
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = NO;
                // 格式化倒计时文本，更新按钮标题
                NSString *formattedCountdownText = [NSString stringWithFormat:countdownText, @(remainingTime)];
                [self setTitle:formattedCountdownText forState:UIControlStateNormal];
                // 如果设置了倒计时背景色，则更改背景色
                if (self.zhh_disabledBackgroundColor) {
                    [self zhh_setBackgroundColor:self.zhh_disabledBackgroundColor forState:UIControlStateNormal];
                }
            });
            remainingTime--;
        }
    });
    dispatch_resume(_timer);
}
@end
