//
//  UIWindow+ZHHHierarchy.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ZHHHierarchy)
/*!
 @method topMostController
 
 @return 返回层次结构中当前最顶层的ViewController.
 */
- (UIViewController*)zhh_topMostController;

/*!
 @method currentViewController
 
 @return 返回topMostController堆栈中的topViewController.
 */
- (UIViewController*)zhh_currentViewController;
@end

NS_ASSUME_NONNULL_END
