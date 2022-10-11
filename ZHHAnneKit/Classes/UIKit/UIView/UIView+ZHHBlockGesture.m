//
//  UIView+ZHHBlockGesture.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIView+ZHHBlockGesture.h"
#import <objc/runtime.h>

static char zhh_kActionHandlerTapBlockKey;
static char zhh_kActionHandlerTapGestureKey;
static char zhh_kActionHandlerLongPressBlockKey;
static char zhh_kActionHandlerLongPressGestureKey;

@implementation UIView (ZHHBlockGesture)
- (void)zhh_addTapActionWithBlock:(ZHHGestureActionBlock)block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhh_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &zhh_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)zhh_handleActionForTapGesture:(UITapGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        ZHHGestureActionBlock block = objc_getAssociatedObject(self, &zhh_kActionHandlerTapBlockKey);
        if (block) {
            block(gesture);
        }
    }
}

- (void)zhh_addLongPressActionWithBlock:(ZHHGestureActionBlock)block {
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey);
    if (!gesture) {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(zhh_handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &zhh_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)zhh_handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        ZHHGestureActionBlock block = objc_getAssociatedObject(self, &zhh_kActionHandlerLongPressBlockKey);
        if (block) {
            block(gesture);
        }
    }
}
@end
