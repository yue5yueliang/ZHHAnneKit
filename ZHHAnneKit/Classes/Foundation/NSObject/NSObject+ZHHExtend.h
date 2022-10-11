//
//  NSObject+ZHHExtend.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZHHExtend)
/// 代码执行时间处理，块中的代码执行
FOUNDATION_EXPORT CFTimeInterval kDoraemonBoxExecuteTimeBlock(void(^block)(void));
/// 延迟点击以避免快速点击
FOUNDATION_EXPORT void kDoraemonBoxAvoidQuickClick(float time);

/// 获取随机数 [to from] 之间的数据
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to;

/// Save to album
/// @param image save the picture
/// @param complete The callback of whether the save is successful or not
- (void)zhh_saveImageToPhotosAlbum:(UIImage *)image complete:(void(^)(BOOL success))complete;
@end

NS_ASSUME_NONNULL_END
