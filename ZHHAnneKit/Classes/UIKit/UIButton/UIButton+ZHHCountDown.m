//
//  UIButton+ZHHCountDown.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHCountDown.h"
#import <objc/runtime.h>

@implementation UIButton (ZHHCountDown)
- (void)zhh_startTime:(NSInteger)timeout countdownFormat:(NSString *)format{
    [self zhh_cancelTimer];
    self.timeOut = timeout;
    self.xxtitle = self.titleLabel.text;
    NSDictionary *info = @{@"countDownFormat":format ?: @"%zd秒"};
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod:) userInfo:info repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:[NSString stringWithFormat:format ?: @"%zd秒",timeout] forState:UIControlStateNormal];
        self.userInteractionEnabled = NO;
    });
}

- (void)timerMethod:(NSTimer *)timer{
    NSString *countDownFormat = timer.userInfo[@"countDownFormat"];
    if (self.timeOut <= 1) {
        [self zhh_cancelTimer];
    } else {
        self.timeOut--;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:[NSString stringWithFormat:countDownFormat,self.timeOut] forState:UIControlStateNormal];
            self.userInteractionEnabled = NO;
        });
    }
}

/// 取消倒计时
- (void)zhh_cancelTimer{
    if (self.timer == nil) return;
    [self.timer invalidate];
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:self.xxtitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.kButtonCountDownStop) { self.kButtonCountDownStop(); }
    });
}

/// 倒计时结束的回调
- (void)zhh_countDownTimeStop:(void(^)(void))withBlock{
    self.kButtonCountDownStop = withBlock;
}

#pragma mark - associated

- (NSTimer *)timer{
    return objc_getAssociatedObject(self, @selector(timer));
}
- (void)setTimer:(NSTimer *)timer{
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)xxtitle{
    return objc_getAssociatedObject(self, @selector(xxtitle));
}
- (void)setXxtitle:(NSString *)xxtitle{
    objc_setAssociatedObject(self, @selector(xxtitle), xxtitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setKButtonCountDownStop:(void(^)(void))kButtonCountDownStop{
    objc_setAssociatedObject(self, @selector(kButtonCountDownStop), kButtonCountDownStop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void(^)(void))kButtonCountDownStop{
    return objc_getAssociatedObject(self, @selector(kButtonCountDownStop));
}
- (NSInteger)timeOut{
    return [objc_getAssociatedObject(self, @selector(timeOut)) integerValue];
}
- (void)setTimeOut:(NSInteger)timeOut{
    objc_setAssociatedObject(self, @selector(timeOut), @(timeOut), OBJC_ASSOCIATION_ASSIGN);
}
@end
