//
//  ZHHCommonTools.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHHCommonTools : NSObject
/// 获取一像素的大小
+ (CGFloat)zhh_pixelOne;
/// 随机生成16位字符串(数字和字母混合)
+ (NSString *)zhh_random16Text;
/** 随机数生成(比如:0~100之间的随机数) */
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to;
/** 表情符号的判断 */
+ (BOOL)zhh_stringContainsEmoji:(NSString *)string;

#pragma mark ------------ json或字符串的解析 ----------------------------
/** json格式字典转字符串格式 */
+ (NSString *)zhh_jsonTextWithJSONObject:(NSDictionary *)object;
/** json格式数组转为 字符串*/
+ (NSString *)zhh_jsonTextWithJSONArray:(NSArray *)jsonArray;
/** 字符串格式转json */
+ (id)zhh_jsonObjectWithJSONText:(NSString *)jsonText;

#pragma mark ------------ 字符串相关格式处理 ----------------------------
/** 以逗号隔开每三位数 */
+ (NSString *)zhh_separatorNumberByComma:(NSInteger)number;
/** 如银行卡字符串格式化 每四位一个空格*/
+ (NSString *)zhh_bankcardNumberFormat:(NSString *)textContent;
/**
 *   把身份证和手机号中间替换成星号的做法
 *
 *   @param replaceText 当前文字
 *   @param index       开始索引
 *   @param length      星号个数
 *   @return 返回已经处理的文字
 */
+ (NSString *)zhh_replaceAsteriskWithText:(NSString *)replaceText index:(NSInteger)index length:(NSInteger)length;
/** 处理空字符串为空的显示 */
+ (NSString *)zhh_showTextNull:(NSString *)parameter;
/** 对字典(Key-Value)排序 不区分大小写 */
+ (NSString *)zhh_sortedDictionaryByCaseConversion:(NSMutableDictionary *)dictionary;
/**
 *  字符串转星期几
 *
 *  @param currentDate 当前日期(2019-04-30)
 *  @return 返回星期-到星期天中的某一天
 */
+ (NSString *)zhh_weekdayStringFromDate:(NSString*)currentDate;
+ (NSString *)zhh_dateWeekWithDateString:(NSString *)dateString;

#pragma mark ------------ 富文本相关的处理 ----------------------------
/**
 *  通过富文本添加图标
 *  @param textStr  当前文字
 *  @param imageArr 需要设置的图标
 *  @param span     间距
 *  @param font     字体
 *  @return 返回已经设置好的富文本
 */
+ (NSAttributedString *)zhh_imageWithText:(NSString *)textStr imageArr:(NSArray<UIImage *> *)imageArr span:(CGFloat)span font:(UIFont *)font;
/**
 *  替换文本字符串
 *
 *  @param currentText 当前的字符串
 *  @param parameter1 需要替换的字符串
 *  @param parameter2 需要替换成的字符串
 */
+ (NSString *)zhh_replaceText:(NSString *)currentText parameter1:(NSString *)parameter1 parameter2:(NSString *)parameter2;
/**
 *  富文本设置文字颜色
 *
 *  @param color        文字颜色
 *  @param currentText  当前的字符串
 *  @param startIndex   开始下标
 *  @param endIndex     结束下标
 */
+ (NSMutableAttributedString *)zhh_mutableAttributedWithColor:(UIColor *)color currentText:(NSString *)currentText startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;
/**
 *  富文本设置文字颜色
 *
 *  @param text 当前的字符串
 *  @param width 需要展示的宽度
 *  @param font 字体
 *  @param lineSpacing 行间距
 */
+ (NSMutableAttributedString *)zhh_setupShowMoreTextLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
/**
 *  根据文字内容动态计算UILabel宽高
 *  @param maxWidth label宽度
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+ (CGSize)zhh_boundingRectWithWidth:(CGFloat)maxWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing text:(NSString *)text;
/**
 *  NSString转换成NSMutableAttributedString
 *  @param text  内容
 *  @param lineSpacing  行间距
 *  @param font  字体
 */
+ (NSMutableAttributedString *)zhh_attributedStringWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
/** 解析成html的富文本 */
+ (NSAttributedString *)zhh_attributedStringWithMaxWidth:(CGFloat)maxWidth htmlText:(NSString *)htmlText;

#pragma mark ------------ 图片存储相关的处理 ----------------------------
/** 据图片名将图片保存到ImageFile文件夹中 */
+ (NSString *)zhh_imageSavedPath:(NSString *)imageName;

/** 获取当前的windows */
+ (UIViewController *)zhh_currentWindow;

/** 获取当前的ViewController */
+ (UIViewController *)zhh_currentVC;

/** 点击获取验证码 */
+ (void)zhh_startCountDown:(UIButton *)sender;

/*
 * 计算经纬度两者之间的距离
 * @param start 开始的经纬度
 * @param end 结束的经纬度
 */
+ (double)zhh_calculateBetweenDistanceStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end;

/// 判断定位功能是否可用
+ (BOOL)zhh_checkLoactionAvailable;
/// 跳转到设置界面设置定位权限
+ (void)zhh_regionFlowCallBlock;
/// 点震动反馈（UIFeedbackGenerator）和系统震动
+ (void)zhh_systemFeedbackGeneratorType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
