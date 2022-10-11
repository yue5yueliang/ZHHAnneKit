//
//  NSString+ZHHCommon.h
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZHHCommon)
/// 转换为URL
@property (nonatomic, strong, readonly) NSURL *URL;
/// 获取图片
@property (nonatomic, strong, readonly) UIImage *image;
/// 图片控制器
@property (nonatomic, strong, readonly) UIImageView *imageView;
/// 文本控件
@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 取出HTML
@property (nonatomic, strong, readonly) NSString *HTMLString;
/// 生成竖直文字
@property (nonatomic, strong, readonly) NSString *verticalText;
/// 是否为JSONString
@property (nonatomic, assign, readonly) BOOL isJSONString;
/// josn字符串到字典
@property (nonatomic, strong, readonly) NSDictionary *JSONDictionary;

/// 字典转Json字符串
extern NSString * kDictionaryToJson(NSDictionary * dict);
/// 数组转Json字符串
extern NSString * kArrayToJson(NSArray * array);
@end

NS_ASSUME_NONNULL_END
