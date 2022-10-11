//
//  UINavigationController+ZHHTransitions.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZHHTransitions)
- (void)zhh_pushViewController:(UIViewController *)controller withTransition:(UIViewAnimationTransition)transition;
- (UIViewController *)zhh_popViewControllerWithTransition:(UIViewAnimationTransition)transition;
@end

NS_ASSUME_NONNULL_END
