//
//  UIButton+ZHHEmitter.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHEmitter)
/// 是否启用粒子效果
@property (nonatomic, assign) BOOL openEmitter;
/// Particles, note that the name attribute should not be changed
@property (nonatomic, strong, readonly) CAEmitterCell * emitterCell;

/// Set particle effect
/// @param image particle image
/// @param open Whether to enable particle effects
- (void)zhh_buttonSetEmitterImage:(UIImage * _Nullable)image openEmitter:(BOOL)open;
@end

NS_ASSUME_NONNULL_END
