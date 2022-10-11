//
//  UIBarButtonItem+ZHHAction.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZHHBarButtonActionBlock)(void);
@interface UIBarButtonItem (ZHHAction)
/// 当UIBarButtonItem被点击时运行的块。
//@property (nonatomic, copy) dispatch_block_t actionBlock;
- (void)setZhh_actionBlock:(ZHHBarButtonActionBlock)actionBlock;
@end

NS_ASSUME_NONNULL_END
