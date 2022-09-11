//
//  UIButton+EnlargeEdge.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/9/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (EnlargeEdge)
/// 扩大按钮单击区域
- (void)zhh_setEnlargeEdge:(CGFloat)size;
/// 扩大按钮单击区域
- (void)zhh_setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end

NS_ASSUME_NONNULL_END
