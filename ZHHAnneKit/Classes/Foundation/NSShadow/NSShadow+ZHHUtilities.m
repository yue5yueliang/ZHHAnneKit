//
//  NSShadow+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSShadow+ZHHUtilities.h"

@implementation NSShadow (ZHHUtilities)

+ (instancetype)qmui_shadowWithColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius {
    NSShadow *shadow = NSShadow.new;
    shadow.shadowColor = shadowColor;
    shadow.shadowOffset = shadowOffset;
    shadow.shadowBlurRadius = shadowRadius;
    return shadow;
}

@end
