//
//  UIView+Animation.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIView+Animation.h"

@interface ZHHAnimationManager ()
@property (nonatomic, assign) NSInteger repeatCount;
@property (nonatomic, assign) CGFloat repeatDuration;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL autoreverses;
@property (nonatomic, assign) NSInteger ease,rotation;
@property (nonatomic, assign) CGFloat multiple;
@property (nonatomic, assign) CGFloat opacity;
@end

@implementation UIView (Animation)

/// 动画组
- (CAAnimationGroup *)zhh_animationMoreAnimations:(NSArray<CABasicAnimation *> *)animations{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = animations;
    [self.layer addAnimation:group forKey:@"animations"];
    return group;
}
- (CABasicAnimation *)zhh_createBasicAnimation:(NSString *)keyPath parameter:(ZHHAnimationManager *)manager{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = manager.duration;
    animation.autoreverses = manager.autoreverses;
    animation.repeatDuration = manager.repeatDuration;
    animation.beginTime = CACurrentMediaTime()+ 0.1;
    animation.repeatCount = manager.repeatCount?:MAXFLOAT;
    return animation;
}
/// 旋转动画效果
- (CABasicAnimation *)zhh_animationRotateClockwise:(BOOL)clockwise makeParameter:(void(^)(ZHHAnimationManager *make))parameter{
    ZHHAnimationManager *manager = [ZHHAnimationManager new];
    if (parameter) parameter(manager);
    NSString *key = @"transform.rotation.z";
    if (manager.rotation == 1) {
        key = @"transform.rotation.x";
    } else if (manager.rotation == 2) {
        key = @"transform.rotation.y";
    }
    CABasicAnimation *animation = [self zhh_createBasicAnimation:key parameter:manager];
    animation.fromValue = @(clockwise ? 0 : M_PI*2);
    animation.toValue   = @(clockwise ? M_PI*2 : 0);
    animation.fillMode = kCAFillModeForwards;
    if (manager.ease == 1) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    } else if (manager.ease == 2) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    } else if (manager.ease == 3) {
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    }
    [self.layer addAnimation:animation forKey:@"rotate-layer"];
    return animation;
}
/// 移动动画效果
- (CABasicAnimation *)zhh_animationMovePoint:(CGPoint)point makeParameter:(void(^)(ZHHAnimationManager *make))parameter{
    ZHHAnimationManager *manager = [ZHHAnimationManager new];
    if (parameter) parameter(manager);
    CABasicAnimation *animation = [self zhh_createBasicAnimation:@"position" parameter:manager];
    animation.fromValue = [NSValue valueWithCGPoint:self.layer.position];
    animation.toValue   = [NSValue valueWithCGPoint:point];
    [self.layer addAnimation:animation forKey:@"move-layer"];
    return animation;
}
/// 缩放动画效果
- (CABasicAnimation *)zhh_animationZoomMultiple:(CGFloat)multiple makeParameter:(void(^)(ZHHAnimationManager *make))parameter{
    ZHHAnimationManager *manager = [ZHHAnimationManager new];
    if (parameter) parameter(manager);
    CABasicAnimation *animation = [self zhh_createBasicAnimation:@"transform.scale" parameter:manager];
    animation.fromValue = @(manager.multiple);
    animation.toValue   = @(multiple);
    [self.layer addAnimation:animation forKey:@"scale-layer"];
    return animation;
}
/// 渐隐动画效果
- (CABasicAnimation *)zhh_animationOpacity:(CGFloat)opacity makeParameter:(void(^)(ZHHAnimationManager *make))parameter{
    ZHHAnimationManager *manager = [ZHHAnimationManager new];
    if (parameter) parameter(manager);
    CABasicAnimation *animation = [self zhh_createBasicAnimation:@"opacity" parameter:manager];
    animation.fromValue = @(opacity);
    animation.toValue   = @(manager.opacity);
    [self.layer addAnimation:animation forKey:@"opacity-layer"];
    return animation;
}

@end

@implementation ZHHAnimationManager

- (instancetype)init{
    if (self = [super init]) {
        self.duration = 5;
        self.repeatCount = 0;
        self.opacity = self.multiple = 1;
    }
    return self;
}
- (ZHHAnimationManager * (^)(NSInteger))kRepeatCount{
    return ^ZHHAnimationManager * (NSInteger xxx) {
        self.repeatCount = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(CGFloat))kRepeatDuration{
    return ^ZHHAnimationManager * (CGFloat xxx) {
        self.repeatDuration = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(CGFloat))kDuration{
    return ^ZHHAnimationManager * (CGFloat xxx) {
        self.duration = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(BOOL))kAutoreverses{
    return ^ZHHAnimationManager * (BOOL boo) {
        self.autoreverses = boo;
        return self;
    };
}
- (ZHHAnimationManager * (^)(NSInteger))kEaseInEaseOut{
    return ^ZHHAnimationManager * (NSInteger xxx) {
        self.ease = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(NSInteger))kTransformRotation{
    return ^ZHHAnimationManager * (NSInteger xxx) {
        self.rotation = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(CGFloat))kBeginMultiple{
    return ^ZHHAnimationManager * (CGFloat xxx) {
        self.multiple = xxx;
        return self;
    };
}
- (ZHHAnimationManager * (^)(CGFloat))kEndOpacity{
    return ^ZHHAnimationManager * (CGFloat xxx) {
        self.opacity = xxx;
        return self;
    };
}
@end
