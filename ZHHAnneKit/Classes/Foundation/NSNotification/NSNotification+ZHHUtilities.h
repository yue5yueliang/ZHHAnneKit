//
//  NSNotification+ZHHUtilities.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNotification (ZHHUtilities)
/**
 *  @brief  获取当前键盘的高度
 *
 *  @discussion 此方法获取键盘的高度，依据设备当前的屏幕方向（竖屏或横屏）。若设备处于横屏状态，将返回键盘的宽度，反之返回高度。
 *  请注意，该方法需要通过键盘显示或隐藏时触发的通知来调用，确保键盘的相关信息有效。
 *
 *  @return 键盘高度，基于当前设备的屏幕方向
 */
- (CGFloat)zhh_keyBoardHeight;
@end

NS_ASSUME_NONNULL_END
