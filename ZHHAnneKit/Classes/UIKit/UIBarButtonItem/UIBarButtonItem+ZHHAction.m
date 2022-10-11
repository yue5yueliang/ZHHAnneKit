//
//  UIBarButtonItem+ZHHAction.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIBarButtonItem+ZHHAction.h"
#import <objc/runtime.h>

char *const UIBarButtonItemZHHActionBlock = "UIBarButtonItemZHHActionBlock";
@implementation UIBarButtonItem (ZHHAction)

- (void)zhh_performActionBlock {
    dispatch_block_t block = self.zhh_actionBlock;
    if (block)
        block();
}

- (ZHHBarButtonActionBlock)zhh_actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemZHHActionBlock);
}

- (void)setZhh_actionBlock:(ZHHBarButtonActionBlock)actionBlock{
    if (actionBlock != self.zhh_actionBlock) {
        
        [self willChangeValueForKey:@"zhh_actionBlock"];
        objc_setAssociatedObject(self, UIBarButtonItemZHHActionBlock,actionBlock,OBJC_ASSOCIATION_COPY);
        
        // Sets up the action.
        [self setTarget:self];
        [self setAction:@selector(zhh_performActionBlock)];
        [self didChangeValueForKey:@"zhh_actionBlock"];
    }
}

@end
