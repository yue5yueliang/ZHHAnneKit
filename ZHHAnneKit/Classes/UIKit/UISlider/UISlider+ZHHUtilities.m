//
//  UISlider+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UISlider+ZHHUtilities.h"
#import <objc/runtime.h>

@implementation UISlider (ZHHUtilities)

/// 开启滑杆点击修改值功能
/// @param enable 是否启用点击修改值功能
/// @param changeHandler 修改值回调
- (void)zhh_enableTapToChangeValue:(BOOL)enable withChangeHandler:(void(^)(float value))changeHandler {
    self.zhh_tapEnabled = enable;
    self.zhh_changeHandler = changeHandler;
}

/// 是否启用点击滑杆修改值功能
- (BOOL)zhh_tapEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZhh_tapEnabled:(BOOL)tapEnabled {
    objc_setAssociatedObject(self, @selector(zhh_tapEnabled), @(tapEnabled), OBJC_ASSOCIATION_ASSIGN);
}

/// 滑杆值修改回调
- (void(^)(float))zhh_changeHandler {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZhh_changeHandler:(void(^)(float))changeHandler {
    objc_setAssociatedObject(self, @selector(zhh_changeHandler), changeHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

/// 重写触摸开始事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (!self.zhh_tapEnabled) return; // 若未启用点击修改值功能，则直接返回

    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    // 计算触摸位置对应的滑杆值
    float value = self.minimumValue + (touchPoint.x - trackRect.origin.x - 4.0) *
                  ((self.maximumValue - self.minimumValue) / (trackRect.size.width - 8.0));
    
    // 更新滑杆值
    [self setValue:value animated:YES];
    
    // 调用回调
    if (self.zhh_changeHandler) {
        self.zhh_changeHandler(value);
    }
}

@end
