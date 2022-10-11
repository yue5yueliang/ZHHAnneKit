//
//  UIButton+ZHHTouchAreaInsets.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/9/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHTouchAreaInsets)
/// 扩大按钮单击区域
/**
 *  @brief  设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets zhh_touchAreaInsets;
@end

NS_ASSUME_NONNULL_END
