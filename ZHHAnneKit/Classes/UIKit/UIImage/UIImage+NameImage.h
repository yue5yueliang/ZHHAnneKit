//
//  UIImage+NameImage.h
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/18.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (NameImage)
/// 根据不同的nickname给不同的群设置含有群名的群头像。
+ (UIImage *)zhh_createTextImageWithString:(NSString *)string imageSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
