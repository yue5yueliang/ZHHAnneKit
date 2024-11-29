//
//  UINavigationItem+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UINavigationItem+ZHHUtilities.h"
#import <objc/runtime.h>

// 使用静态键关联属性
static void *ZHHLoaderPositionAssociationKey = &ZHHLoaderPositionAssociationKey;
static void *ZHHSubstitutedViewAssociationKey = &ZHHSubstitutedViewAssociationKey;

@implementation UINavigationItem (ZHHUtilities)
// 开始加载动画，指定位置
- (void)zhh_startLoadingAnimationAtPosition:(ZHHNavBarLoaderPosition)position indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle{
    // 如果正在执行加载动画，先停止
    [self zhh_stopLoadingAnimation];
    
    // 保存当前位置，稍后恢复
    objc_setAssociatedObject(self, ZHHLoaderPositionAssociationKey, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 创建加载指示器
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
    
    // 根据指定位置替换相应的导航栏视图
    switch (position) {
        case ZHHNavBarLoaderPositionLeft:
            objc_setAssociatedObject(self, ZHHSubstitutedViewAssociationKey, self.leftBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.leftBarButtonItem.customView = loader;
            break;
            
        case ZHHNavBarLoaderPositionCenter:
            objc_setAssociatedObject(self, ZHHSubstitutedViewAssociationKey, self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.titleView = loader;
            break;
            
        case ZHHNavBarLoaderPositionRight:
            objc_setAssociatedObject(self, ZHHSubstitutedViewAssociationKey, self.rightBarButtonItem.customView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.rightBarButtonItem.customView = loader;
            break;
    }
    
    // 启动加载指示器
    [loader startAnimating];
}

// 停止加载动画并恢复原来的视图
- (void)zhh_stopLoadingAnimation {
    // 获取之前存储的加载位置和视图
    NSNumber *positionToRestore = objc_getAssociatedObject(self, ZHHLoaderPositionAssociationKey);
    id componentToRestore = objc_getAssociatedObject(self, ZHHSubstitutedViewAssociationKey);
    
    // 如果之前有动画，恢复原来的视图
    if (positionToRestore) {
        switch (positionToRestore.intValue) {
            case ZHHNavBarLoaderPositionLeft:
                self.leftBarButtonItem.customView = componentToRestore;
                break;
            case ZHHNavBarLoaderPositionCenter:
                self.titleView = componentToRestore;
                break;
            case ZHHNavBarLoaderPositionRight:
                self.rightBarButtonItem.customView = componentToRestore;
                break;
        }
    }
    
    // 清除关联的对象，准备下次使用
    objc_setAssociatedObject(self, ZHHLoaderPositionAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, ZHHSubstitutedViewAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
