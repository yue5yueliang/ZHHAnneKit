//
//  UITextField+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UITextField (ZHHExtend)
/// 占位符颜色
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
/// 占位符文本的字体大小
@property (nonatomic, assign) IBInspectable CGFloat placeholderFontSize;
/// 最大长度
@property (nonatomic, assign) IBInspectable NSInteger maxLength;
/// 在纯文本和暗文本之间切换
@property (nonatomic, assign) BOOL securePasswords;
/// 是否显示键盘上方的操作栏和顶部完成按钮
@property (nonatomic, assign) BOOL displayInputAccessoryView;

/// 已达到最大字符长度
- (void)maxLengthWithBlock:(void(^)(NSString * text))withBlock;
/// 文本编辑时刻
- (void)textEditingChangedWithBolck:(void(^)(NSString * text))withBlock;
@end

NS_ASSUME_NONNULL_END
