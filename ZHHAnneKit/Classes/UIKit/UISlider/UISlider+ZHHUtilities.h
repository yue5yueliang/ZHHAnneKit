//
//  UISlider+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (ZHHUtilities)
/// 启用滑杆点击修改值功能
/// @param enable 是否启用点击修改值功能
/// @param changeHandler 值修改回调
- (void)zhh_enableTapToChangeValue:(BOOL)enable withChangeHandler:(void(^)(float value))changeHandler;

@end

NS_ASSUME_NONNULL_END
