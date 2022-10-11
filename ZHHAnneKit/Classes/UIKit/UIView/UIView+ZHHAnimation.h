//
//  UIView+ZHHAnimation.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHHAnimationManager;
@interface UIView (ZHHAnimation)
/// Animation group
- (CAAnimationGroup *)zhh_animationMoreAnimations:(NSArray<CABasicAnimation *> *)animations;

/// Rotation animation effect
- (CABasicAnimation *)zhh_animationRotateClockwise:(BOOL)clockwise
                                     makeParameter:(void(^)(ZHHAnimationManager *make))parameter;

/// Moving animation effect
- (CABasicAnimation *)zhh_animationMovePoint:(CGPoint)point
                               makeParameter:(void(^)(ZHHAnimationManager *make))parameter;

/// Zoom animation effect
- (CABasicAnimation *)zhh_animationZoomMultiple:(CGFloat)multiple
                                  makeParameter:(void(^)(ZHHAnimationManager *make))parameter;

/// Fading animation effect
- (CABasicAnimation *)zhh_animationOpacity:(CGFloat)opacity
                             makeParameter:(void(^)(ZHHAnimationManager *make))parameter;

@end


@interface ZHHAnimationManager : NSObject

#pragma mark - public part
/// The number of repetitions, the default has been repeated
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kRepeatCount)(NSInteger);
/// Repeat time
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kRepeatDuration)(CGFloat);
/// Duration, 5 seconds by default
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kDuration)(CGFloat);
/// Whether to perform inverse animation, default NO
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kAutoreverses)(BOOL);

#pragma mark - Rotating part
/// Rotation speed,
/// 1: first slow and then slow,
/// 2: first slow and then fast,
/// 3: first fast and then slow,
/// others: uniform speed
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kEaseInEaseOut)(NSInteger);
/// Flip axis, 0: z axis, 1: x axis, 2: y axis
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kTransformRotation)(NSInteger);

#pragma mark - zoom part
/// The magnification at the beginning, the default is 1
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kBeginMultiple)(CGFloat);

#pragma mark - fade part
/// The hiding coefficient at the end, the default is 1
@property (nonatomic, copy, readonly) ZHHAnimationManager *(^kEndOpacity)(CGFloat);

@end

NS_ASSUME_NONNULL_END
