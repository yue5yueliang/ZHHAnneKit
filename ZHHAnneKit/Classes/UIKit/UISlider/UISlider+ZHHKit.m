//
//  UISlider+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UISlider+ZHHKit.h"
#import <objc/runtime.h>

@implementation UISlider (ZHHKit)
/// 开启滑杆点击修改值
/// @param tap 是否开启手动点击
/// @param withBlock 修改值回调
- (void)zhh_openTapChangeValue:(BOOL)tap withBlock:(void(^)(float value))withBlock{
    self.openTap = tap;
    self.withBlock = withBlock;
}

- (BOOL)openTap{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setOpenTap:(BOOL)openTap{
    objc_setAssociatedObject(self, @selector(openTap), [NSNumber numberWithBool:openTap], OBJC_ASSOCIATION_ASSIGN);
}
- (void(^)(float))withBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setWithBlock:(void(^)(float))withBlock{
    objc_setAssociatedObject(self, @selector(withBlock), withBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.openTap == NO) return;
    CGRect rect = [self trackRectForBounds:self.bounds];
    float value = [self minimumValue] + ([[touches anyObject] locationInView: self].x - rect.origin.x - 4.0) * (([self maximumValue] - [self minimumValue]) / (rect.size.width - 8.0));
    [self setValue:value];
    self.withBlock ? self.withBlock(value) : nil;
}
@end
