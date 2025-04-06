//
//  NSShadow+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSShadow (ZHHUtilities)

+ (instancetype)qmui_shadowWithColor:(nullable UIColor *)shadowColor
                        shadowOffset:(CGSize)shadowOffset
                        shadowRadius:(CGFloat)shadowRadius;
@end

NS_ASSUME_NONNULL_END
