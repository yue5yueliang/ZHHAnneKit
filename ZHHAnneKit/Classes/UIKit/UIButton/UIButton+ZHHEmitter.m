//
//  UIButton+ZHHEmitter.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIButton+ZHHEmitter.h"
#import <objc/runtime.h>


@implementation UIButton (ZHHEmitter)
#pragma mark - 设置粒子效果
- (void)zhh_setEmitterImage:(UIImage *)image openEmitter:(BOOL)open {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(
            class_getInstanceMethod(self.class, @selector(setSelected:)),
            class_getInstanceMethod(self.class, @selector(zhh_setSelected:))
        );
    });
    self.zhh_emitterImage = image;
    self.zhh_openEmitter = open;
    [self zhh_setupEmitterLayer];
}

#pragma mark - 方法交换
- (void)zhh_setSelected:(BOOL)selected {
    [self zhh_setSelected:selected];
    if (self.zhh_openEmitter) [self zhh_startAnimation];
}

#pragma mark - Associated Properties

- (UIImage *)zhh_emitterImage {
    return objc_getAssociatedObject(self, @selector(zhh_emitterImage));
}

- (void)setZhh_emitterImage:(UIImage *)emitterImage {
    objc_setAssociatedObject(self, @selector(zhh_emitterImage), emitterImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zhh_openEmitter {
    return [objc_getAssociatedObject(self, @selector(zhh_openEmitter)) boolValue];
}

- (void)setZhh_openEmitter:(BOOL)openEmitter {
    objc_setAssociatedObject(self, @selector(zhh_openEmitter), @(openEmitter), OBJC_ASSOCIATION_ASSIGN);
}

- (CAEmitterLayer *)zhh_explosionLayer {
    return objc_getAssociatedObject(self, @selector(zhh_explosionLayer));
}

- (void)setZhh_explosionLayer:(CAEmitterLayer *)explosionLayer {
    objc_setAssociatedObject(self, @selector(zhh_explosionLayer), explosionLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAEmitterCell *)zhh_emitterCell {
    return objc_getAssociatedObject(self, @selector(zhh_emitterCell));
}

- (void)setZhh_emitterCell:(CAEmitterCell *)emitterCell {
    objc_setAssociatedObject(self, @selector(zhh_emitterCell), emitterCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 粒子效果相关

- (void)zhh_setupEmitterLayer {
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.name = @"zhh_name";
    emitterCell.alphaRange = 0.10;
    emitterCell.lifetime = 0.7;
    emitterCell.lifetimeRange = 0.3;
    emitterCell.velocity = 40.00;
    emitterCell.velocityRange = 10.00;
    emitterCell.scale = 0.04;
    emitterCell.scaleRange = 0.02;
    emitterCell.contents = (id)self.zhh_emitterImage.CGImage;
    self.zhh_emitterCell = emitterCell;

    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.name = @"zhh_emitterLayer";
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.emitterSize = CGSizeMake(10, 0);
    emitterLayer.emitterCells = @[emitterCell];
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    emitterLayer.position = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    emitterLayer.zPosition = -1;
    [self.layer addSublayer:emitterLayer];
    self.zhh_explosionLayer = emitterLayer;
}

#pragma mark - 动画

- (void)zhh_startAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    if (self.selected) {
        animation.values = @[@1.5, @0.8, @1.0, @1.2, @1.0];
        animation.duration = 0.4;
        self.zhh_explosionLayer.beginTime = CACurrentMediaTime();
        [self.zhh_explosionLayer setValue:@2000 forKeyPath:@"emitterCells.zhh_name.birthRate"];
        [self performSelector:@selector(zhh_stopEmitter) withObject:nil afterDelay:0.2];
    } else {
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.2;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
}

- (void)zhh_stopEmitter {
    [self.zhh_explosionLayer setValue:@0 forKeyPath:@"emitterCells.zhh_name.birthRate"];
}
@end
