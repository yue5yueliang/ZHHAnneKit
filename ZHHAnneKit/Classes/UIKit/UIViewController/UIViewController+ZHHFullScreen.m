//
//  UIViewController+ZHHFullScreen.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIViewController+ZHHFullScreen.h"
#import <objc/runtime.h>

@implementation UIViewController (ZHHFullScreen)

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        [navigationController setNavigationBarHidden:NO animated:YES];
        if (navigationController.delegate == self) {
            navigationController.delegate = nil;
        }
    }
}

/// 是否开启侧滑返回手势
- (void)zhh_openPopGesture:(BOOL)open{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        for (UIGestureRecognizer * popGesture in
             self.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = open;
        }
    }
}

/// 系统自带分享
- (UIActivityViewController *)zhh_shareActivityWithItems:(NSArray *)items complete:(void(^)(BOOL))complete{
    if (items.count == 0) return nil;
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {
        vc.excludedActivityTypes = @[
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypeOpenInIBooks,
            UIActivityTypeMarkupAsPDF
        ];
    } else if (@available(iOS 9.0, *)) {
        vc.excludedActivityTypes = @[
            UIActivityTypeMessage,
            UIActivityTypeMail,
            UIActivityTypeOpenInIBooks
        ];
    } else {
        vc.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypeMail];
    }
    vc.completionWithItemsHandler = ^(UIActivityType activityType, BOOL completed,
                                      NSArray * returnedItems, NSError * activityError) {
        if (complete) complete(completed);
    };
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        vc.popoverPresentationController.sourceView = self.view;
        vc.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height, 0, 0);
    }
    [self presentViewController:vc animated:YES completion:nil];
    return vc;
}
@end
