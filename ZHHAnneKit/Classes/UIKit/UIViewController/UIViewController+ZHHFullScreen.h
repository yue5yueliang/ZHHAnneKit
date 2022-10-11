//
//  UIViewController+ZHHFullScreen.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZHHFullScreen)<UINavigationControllerDelegate>
/// 是否打开向后滑动手势
- (void)zhh_openPopGesture:(BOOL)open;

/// 该系统附带共享功能
/// @param items 共享数据
/// @param complete 共享完成回调处理
/// @return Return 共享控制器
- (UIActivityViewController *)zhh_shareActivityWithItems:(NSArray *)items complete:(nullable void(^)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
