//
//  UITextView+ZHHBackout.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ZHHBackout)
/// 是否启用取消功能
@property (nonatomic, assign) BOOL openBackout;

/// 撤销输入，相当于 command + z
- (void)zhh_textViewBackout;
@end

NS_ASSUME_NONNULL_END
