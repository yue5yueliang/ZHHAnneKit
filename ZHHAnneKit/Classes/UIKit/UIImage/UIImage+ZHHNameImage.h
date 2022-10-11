//
//  UIImage+ZHHNameImage.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/18.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZHHNameImage)
/// 根据不同的nickname给不同的群设置含有群名的群头像。
+ (UIImage *)zhh_createTextImageWithString:(NSString *)string imageSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
