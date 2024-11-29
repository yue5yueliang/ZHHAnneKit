//
//  UIButton+ZHHEmitter.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHEmitter)

/// 设置粒子效果
/// @param image 粒子图像
/// @param open 是否开启粒子效果
- (void)zhh_setEmitterImage:(UIImage *)image openEmitter:(BOOL)open;

/// 开始动画效果
- (void)zhh_startAnimation;

/// 停止粒子效果
- (void)zhh_stopEmitter;

#pragma mark - Properties

/// 获取/设置粒子图像
@property (nonatomic, strong) UIImage *zhh_emitterImage;

/// 获取/设置是否开启粒子效果
@property (nonatomic, assign) BOOL zhh_openEmitter;

/// 获取/设置爆炸效果层
@property (nonatomic, strong) CAEmitterLayer *zhh_explosionLayer;

/// 获取/设置粒子效果细节
@property (nonatomic, strong) CAEmitterCell *zhh_emitterCell;
@end

NS_ASSUME_NONNULL_END
