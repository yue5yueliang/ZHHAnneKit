//
//  UISlider+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (ZHHExtend)
/// 打开滑块并单击以修改值
/// @param tap Whether to enable manual tap
/// @param withBlock modify value callback
- (void)zhh_openTapChangeValue:(BOOL)tap withBlock:(void(^)(float value))withBlock;
@end

NS_ASSUME_NONNULL_END
