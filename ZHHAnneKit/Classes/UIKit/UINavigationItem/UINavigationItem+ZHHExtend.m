//
//  UINavigationItem+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UINavigationItem+ZHHExtend.h"
#import <objc/runtime.h>

@interface UIButton (UINavigationItemButtonExtension)

- (void)navigationAddAction:(void(^)(UIButton * kButton))block;

@end

@implementation UIButton (UINavigationItemButtonExtension)

- (void)navigationAddAction:(void(^)(UIButton * kButton))block{
    SEL selector = NSSelectorFromString(@"kNavigationItemButtonAction");
    objc_setAssociatedObject(self, selector, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
}
- (void)kNavigationItemButtonAction{
    void (^withBlock)(UIButton *) = objc_getAssociatedObject(self, _cmd);
    if (withBlock) withBlock(self);
}

@end

@implementation UINavigationItem (ZHHExtend)
/// 链式生成
- (instancetype)zhh_makeNavigationItem:(void(^)(UINavigationItem *make))block{
    if (block) block(self);
    return self;
}
- (UIBarButtonItem *)zhh_barButtonItemWithTitle:(NSString *)title
                                     titleColor:(UIColor *)color
                                          image:(UIImage *)image
                                      tintColor:(UIColor *)tintColor
                                    buttonBlock:(void(^)(UIButton *))block
                                 barButtonBlock:(void(^)(UIButton *))withBlock{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        if (tintColor) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button.imageView setTintColor:tintColor];
        } else {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [button setImage:image forState:UIControlStateNormal];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    [button sizeToFit];
    [button navigationAddAction:block];
    if (withBlock) withBlock(button);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - chain parameter

- (UINavigationItem * (^)(void(^)(ZHHNavigationItemInfo *),void(^)(UIButton *)))kAddBarButtonItemInfo{
    return ^ UINavigationItem * (void(^xblock)(ZHHNavigationItemInfo *), void(^block)(UIButton *)){
        ZHHNavigationItemInfo *info = [ZHHNavigationItemInfo new];
        if (xblock) xblock(info);
        UIBarButtonItem * barButtonItem = [self zhh_barButtonItemWithTitle:info.title
                                                                titleColor:info.color
                                                                     image:[UIImage imageNamed:info.imageName]
                                                                 tintColor:info.tintColor
                                                               buttonBlock:block
                                                            barButtonBlock:info.barButton];
        if (info.isLeft) {
            return self.kAddLeftBarButtonItem(barButtonItem);
        } else {
            return self.kAddRightBarButtonItem(barButtonItem);
        }
    };
}
- (UINavigationItem * (^)(UIBarButtonItem *))kAddLeftBarButtonItem{
    return ^ UINavigationItem * (UIBarButtonItem * barButtonItem){
        if (self.leftBarButtonItem == nil) {
            self.leftBarButtonItem = barButtonItem;
        } else {
            if (self.leftBarButtonItems.count == 0) {
                self.leftBarButtonItems = @[self.leftBarButtonItem,barButtonItem];
            } else {
                NSMutableArray * items = [NSMutableArray arrayWithArray:self.leftBarButtonItems];
                [items addObject:barButtonItem];
                self.leftBarButtonItems = items;
            }
        }
        return self;
    };
}
- (UINavigationItem * (^)(UIBarButtonItem *))kAddRightBarButtonItem{
    return ^ UINavigationItem * (UIBarButtonItem * barButtonItem){
        if (self.rightBarButtonItem == nil) {
            self.rightBarButtonItem = barButtonItem;
        } else {
            if (self.rightBarButtonItems.count == 0) {
                self.rightBarButtonItems = @[self.rightBarButtonItem,barButtonItem];
            } else {
                NSMutableArray * items = [NSMutableArray arrayWithArray:self.rightBarButtonItems];
                [items addObject:barButtonItem];
                self.rightBarButtonItems = items;
            }
        }
        return self;
    };
}

@end

@implementation ZHHNavigationItemInfo

- (instancetype)init{
    if (self = [super init]) {
        self.color = UIColor.whiteColor;
        self.isLeft = YES;
    }
    return self;
}

@end
