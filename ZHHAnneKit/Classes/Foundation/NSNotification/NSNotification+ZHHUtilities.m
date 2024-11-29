//
//  NSNotification+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSNotification+ZHHUtilities.h"

@implementation NSNotification (ZHHUtilities)
/**
 *  @brief  获取当前键盘的高度
 *
 *  @discussion 此方法获取键盘的高度，依据设备当前的屏幕方向（竖屏或横屏）。若设备处于横屏状态，将返回键盘的宽度，反之返回高度。
 *  请注意，该方法需要通过键盘显示或隐藏时触发的通知来调用，确保键盘的相关信息有效。
 *
 *  @return 键盘高度，基于当前设备的屏幕方向
 */
- (CGFloat)zhh_keyBoardHeight {
    // 获取键盘显示或隐藏时的通知信息
    NSDictionary *userInfo = [self userInfo];
    
    // 判断 userInfo 是否有效且包含键盘框架信息
    if (userInfo && userInfo[UIKeyboardFrameEndUserInfoKey]) {
        // 获取键盘结束时的 frame 并提取其大小
        CGSize size = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        // 获取当前设备的屏幕方向（适配 iOS 13 及更高版本）
        UIWindowScene *windowScene = (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.anyObject;
        UIInterfaceOrientation orientation = windowScene.interfaceOrientation;
        
        // 如果设备是横屏，返回键盘的宽度；否则返回键盘的高度
        return UIInterfaceOrientationIsLandscape(orientation) ? size.width : size.height;
    }
    
    // 若无有效信息，返回 0 或其他默认值
    return 0;
}
@end
