//
//  UIControl+ZHHSound.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ZHHSound)

/// Set the sound for a particular control event (or events).
/// @param name The name of the file. The method looks for an image with the specified name in the application’s main bundle.
/// @param controlEvent A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
// 不同事件增加不同声音
- (void)zhh_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent;
@end

NS_ASSUME_NONNULL_END
