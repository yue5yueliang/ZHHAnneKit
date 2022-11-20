//
//  UIButton+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (ZHHExtend)
/// 自定义button属性
@property (nonatomic, copy) NSString *zhh_identifier;
/**
 *  创建普通按钮
 *  @param title         标题
 *  @param titleColor    字体颜色
 *  @param font          字号
 *  @return UIButton
 */
+ (instancetype)zhh_buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
