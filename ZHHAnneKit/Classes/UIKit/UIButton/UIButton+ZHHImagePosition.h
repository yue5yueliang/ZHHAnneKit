//
//  UIButton+ZHHImagePosition.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/2.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZHHImagePosition) {
    /// 图片在左，文字在右，默认
    ZHHImagePositionLeft = 0,
    /// 图片在右，文字在左
    ZHHImagePositionRight = 1,
    /// 图片在上，文字在下
    ZHHImagePositionTop = 2,
    /// 图片在下，文字在上
    ZHHImagePositionBottom = 3
};

@interface UIButton (ZHHImagePosition)
- (void)zhh_setButtonImageWithURL:(NSString *)imageURL;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)zhh_setButtonTitleWithImagePosition:(ZHHImagePosition)postion spacing:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
