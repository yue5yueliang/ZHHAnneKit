//
//  UINavigationItem+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHHNavigationItemInfo;
@interface UINavigationItem (ZHHExtend)
/// 链式生成
- (instancetype)zhh_makeNavigationItem:(void(^)(UINavigationItem *make))block;

/// 快捷生成方法
/// @param title title
/// @param color title text color
/// @param image image
/// @param tintColor can modify the color of the picture
/// @param block click callback
/// @param withBlock return to the internal button
- (UIBarButtonItem *)zhh_barButtonItemWithTitle:(NSString *)title
                                     titleColor:(UIColor *)color
                                          image:(UIImage *)image
                                      tintColor:(UIColor *)tintColor
                                    buttonBlock:(void(^)(UIButton * sender))block
                                 barButtonBlock:(void(^)(UIButton * sender))withBlock;

#pragma mark - chain parameter

@property (nonatomic, strong, readonly) UINavigationItem *(^kAddBarButtonItemInfo)
(void(^)(ZHHNavigationItemInfo *info), void(^)(UIButton * sender));
@property (nonatomic, strong, readonly) UINavigationItem *(^kAddLeftBarButtonItem)(UIBarButtonItem *);
@property (nonatomic, strong, readonly) UINavigationItem *(^kAddRightBarButtonItem)(UIBarButtonItem *);
@end

/// Configuration parameters
@interface ZHHNavigationItemInfo: NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
/// Picture color, default white
@property (nonatomic, strong) UIColor *tintColor;
/// Text color, default white
@property (nonatomic, strong) UIColor *color;
/// Whether it is the left item, the default yes
@property (nonatomic, assign) BOOL isLeft;
/// Internal button for external modification of parameters
@property (nonatomic, copy, readwrite) void(^barButton)(UIButton * barButton);

@end
NS_ASSUME_NONNULL_END
