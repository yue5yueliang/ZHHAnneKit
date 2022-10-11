//
//  UINavigationItem+ZHHLoading.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UINavigationItem+ZHHLoading.h"
#import <objc/runtime.h>

static void *ZHHLoaderPositionAssociationKey = &ZHHLoaderPositionAssociationKey;
static void *ZHHSubstitutedViewAssociationKey = &ZHHSubstitutedViewAssociationKey;

@implementation UINavigationItem (ZHHLoading)
- (void)zhh_startAnimatingAt:(ZHHNavBarLoaderPosition)position {
    // stop previous if animated
    [self zhh_stopAnimating];
    
    // hold reference for position to stop at the right place
    objc_setAssociatedObject(self, ZHHLoaderPositionAssociationKey, @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // substitute bar views to loader and hold reference to them for restoration
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
    
    [loader startAnimating];
}

- (void)zhh_stopAnimating {
    NSNumber* positionToRestore = objc_getAssociatedObject(self, ZHHLoaderPositionAssociationKey);
    id componentToRestore = objc_getAssociatedObject(self, ZHHSubstitutedViewAssociationKey);
    
    // restore UI if animation was in a progress
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
    objc_setAssociatedObject(self, ZHHLoaderPositionAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, ZHHSubstitutedViewAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
