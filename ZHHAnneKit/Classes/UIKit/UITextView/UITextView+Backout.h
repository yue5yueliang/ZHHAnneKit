//
//  UITextView+Backout.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/4.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Backout)
/// 是否启用取消功能
@property (nonatomic, assign) BOOL openBackout;

/// 撤销输入，相当于 command + z
- (void)zhh_textViewBackout;
@end

NS_ASSUME_NONNULL_END
