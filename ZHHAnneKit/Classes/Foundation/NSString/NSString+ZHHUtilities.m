//
//  NSString+ZHHUtilities.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/8/4.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "NSString+ZHHUtilities.h"
#import <CoreText/CoreText.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (ZHHUtilities)

/// @brief  将中文字符串转换为拼音（去除空格和音标）
/// @return 转换后的拼音字符串（如“你好”返回“nihao”）
- (NSString *)zhh_pinyin {
    return [[self zhh_chineseToPinYin] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// 返回当前字符串的本地化版本
- (NSString *)zhh_localized {
    return NSLocalizedString(self, nil);
}

/// @brief  获取字符串的拼音首字母
/// @return 拼音首字母字符串（如“张三”返回“ZS”）
- (NSString *)zhh_pinyinInitial {
    if (self.length == 0) {
        return nil;
    }

    // 获取拼音字符串（带空格）
    NSString *pinyinString = [self zhh_chineseToPinYin];
    // 按空格分割拼音字符串
    NSArray<NSString *> *words = [pinyinString componentsSeparatedByString:@" "];
    // 拼接每个拼音的首字母
    NSMutableString *initials = [[NSMutableString alloc] initWithCapacity:words.count];
    for (NSString *word in words) {
        if (word.length > 0) {
            [initials appendString:[word substringToIndex:1].uppercaseString];
        }
    }
    return initials;
}

/// @brief  将中文字符串转换为拼音（保留空格，去除音标）
/// @return 转换后的拼音字符串（如“你好”返回“ni hao”）
- (NSString *)zhh_chineseToPinYin {
    if (self.length == 0) {
        return @"";
    }
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    // 转为带声调的拉丁文
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformMandarinLatin, NO);
    // 去掉声调
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, NO);
    return mutableString;
}

/// @brief  获取中文字符串拼音首字母的大写形式
/// @return 拼音首字母的大写字符串（如“你好”返回“N”）
- (NSString *)zhh_firstUppercasePinYin {
    NSString *pinyinString = [self zhh_chineseToPinYin];
    return pinyinString.length > 0 ? [[pinyinString substringToIndex:1] uppercaseString] : nil;
}

#pragma mark - 核心方法实现
/// @brief 计算文本尺寸 (默认断行模式为 NSLineBreakByWordWrapping)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [self zhh_sizeWithFont:font maxWidth:maxWidth lineBreakMode:NSLineBreakByWordWrapping lineSpacing:0];
}

/// @brief 计算文本尺寸 (指定断行模式)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineBreakMode 断行模式
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self zhh_sizeWithFont:font maxWidth:maxWidth lineBreakMode:lineBreakMode lineSpacing:0];
}

/// @brief 计算文本尺寸 (指定行间距，断行模式默认为 NSLineBreakByWordWrapping)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpacing:(CGFloat)lineSpacing {
    return [self zhh_sizeWithFont:font maxWidth:maxWidth lineBreakMode:NSLineBreakByWordWrapping lineSpacing:lineSpacing];
}

/// @brief 计算文本尺寸 (指定断行模式和行间距)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param lineBreakMode 断行模式
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing {
    return [self zhh_sizeWithFont:font maxWidth:maxWidth alignment:NSTextAlignmentLeft lineBreakMode:lineBreakMode lineSpacing:lineSpacing];
}

/// @brief 计算文本尺寸 (指定对齐方式、断行模式和行间距)
/// @param font 字体，不能为空
/// @param maxWidth 最大宽度（为 0 或负数时表示不限制宽度）
/// @param alignment 对齐方式
/// @param lineBreakMode 断行模式
/// @param lineSpacing 行间距
/// @return 计算得出的文本尺寸 (宽度和高度)
- (CGSize)zhh_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineSpacing:(CGFloat)lineSpacing {
    if (self.length == 0 || font == nil) return CGSizeZero;

    // 配置段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = lineBreakMode;
    if (lineSpacing > 0) {
        paragraphStyle.lineSpacing = lineSpacing;
    }

    // 配置文本属性
    NSDictionary *attributes = @{
        NSFontAttributeName: font,
        NSParagraphStyleAttributeName: paragraphStyle
    };

    // 约束宽度
    CGFloat constrainedWidth = maxWidth > 0 ? maxWidth : CGFLOAT_MAX;
    CGSize constrainedSize = CGSizeMake(constrainedWidth, CGFLOAT_MAX);

    // 计算尺寸
    CGSize boundingSize = [self boundingRectWithSize:constrainedSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:attributes
                                             context:nil].size;

    // 返回向上取整的尺寸
    return CGSizeMake(ceil(boundingSize.width), ceil(boundingSize.height));
}

/// @brief  返回字符串的反转版本
/// @return 反转后的字符串
- (NSString *)zhh_reversedString {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSInteger charIndex = self.length;
    while (charIndex > 0) {
        charIndex--;
        [result appendString:[self substringWithRange:NSMakeRange(charIndex, 1)]];
    }
    return result;
}

/// @brief  计算单行文本的尺寸（支持包含 emoji 表情的计算，支持首尾空格；不计算图片的尺寸）
/// @param font 字体对象，用于计算文本尺寸
/// @return 文本单行显示所需的 CGSize
- (CGSize)zhh_singleLineSizeWithFont:(UIFont *)font {
    // 如果字体为空，直接返回 CGSizeZero
    if (font == nil) { return CGSizeZero; }

    // 创建 Core Text 字体对象
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    if (!cfFont) {
        return CGSizeZero;
    }
    
    // 计算行间距
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    // 设置段落样式，主要调整行间距
    CTParagraphStyleSetting paragraphSettings[1] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &leading}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    if (!paragraphStyle) {
        CFRelease(cfFont);
        return CGSizeZero;
    }
    
    // 创建 CFRange，表示文本的范围
    CFRange textRange = CFRangeMake(0, self.length);
    // 创建可变的 CFAttributedString，用于存储带属性的字符串
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    if (!string) {
        CFRelease(paragraphStyle);
        CFRelease(cfFont);
        return CGSizeZero;
    }
    
    // 将当前 NSString 转换为 CFString，并替换到 CFAttributedString 中
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef)self);
    // 设置字体属性
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    // 设置段落样式属性
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    // 创建一个文本框架的构造器
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    if (!framesetter) {
        CFRelease(paragraphStyle);
        CFRelease(string);
        CFRelease(cfFont);
        return CGSizeZero;
    }
    
    // 计算文本尺寸，宽度无限制，高度仅为单行
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    // 释放 Core Foundation 对象，避免内存泄漏
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

/// @brief  计算 NSString 在指定宽度和字体下的分行内容
/// @param font  字体对象，用于计算文本行数
/// @param maxWidth 约束宽度
/// @return 包含每行内容的数组
- (NSArray<NSString *> *)zhh_linesWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    // 如果字符串为空，直接返回 nil
    if (self.length == 0 || font == nil) {
        return nil;
    }

    // 创建 Core Text 字体对象
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)(font.fontName), font.pointSize, NULL);
    if (!ctFont) {
        return nil;
    }

    // 创建富文本字符串，包含段落样式
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping; // 按字符换行
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:NSMakeRange(0, attributedString.length)];
    CFRelease(ctFont);

    // 创建 CTFramesetter
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    if (!frameSetter) {
        return nil;
    }

    // 设置绘制区域，宽度受限，高度设置为足够大
    CGMutablePathRef path = CGPathCreateMutable();
    if (!path) {
        CFRelease(frameSetter);
        return nil;
    }
    
    CGPathAddRect(path, NULL, CGRectMake(0, 0, maxWidth, CGFLOAT_MAX));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    if (!frame) {
        CGPathRelease(path);
        CFRelease(frameSetter);
        return nil;
    }

    // 获取每行内容
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    NSMutableArray<NSString *> *linesArray = [[NSMutableArray alloc] init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef)line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [self substringWithRange:range];
        [linesArray addObject:lineString];
    }

    // 释放 Core Foundation 对象，防止内存泄漏
    CGPathRelease(path);
    CFRelease(frame);
    CFRelease(frameSetter);

    return linesArray;
}

/// @brief  将文字转换为图片
/// @param size            图片的尺寸
/// @param backgroundColor 图片背景颜色
/// @param attributes      文字属性（如字体、颜色等，使用 `NSAttributedString` 的属性键）
/// @return 生成的 UIImage 对象
- (UIImage *)zhh_imageFromTextWithSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor textAttributes:(NSDictionary *)attributes {
    // 定义绘制区域
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    // 开始图形上下文绘制
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 填充背景颜色
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, bounds);
    // 计算文字尺寸
    CGSize textSize = [self sizeWithAttributes:attributes];
    // 绘制文字在居中位置
    CGRect textRect = CGRectMake((bounds.size.width - textSize.width) / 2, (bounds.size.height - textSize.height) / 2, textSize.width, textSize.height);
    [self drawInRect:textRect withAttributes:attributes];
    // 从上下文获取生成的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return image;
}

/// 安全截取字符串（前提：确保截取范围合法）
/// @param range 范围（起始位置和长度）
- (NSString *)zhh_safeSubstringWithRange:(NSRange)range {
    if (self == nil || [self isEqualToString:@""] || range.location >= self.length) {
        return @"";
    }
    // 处理范围超出长度的情况
    if (NSMaxRange(range) > self.length) {
        range.length = self.length - range.location;
    }
    return [self substringWithRange:range];
}

/// 安全地截取从起始位置到指定位置的字符串
/// @param index 截取的结束位置
- (NSString *)zhh_safeSubstringToIndex:(NSUInteger)index {
    return [self zhh_safeSubstringWithRange:NSMakeRange(0, index)];
}

/// 安全地截取从指定位置到字符串结尾的部分
/// @param from 截取的起始位置
- (NSString *)zhh_safeSubstringFromIndex:(NSInteger)from {
    return [self zhh_safeSubstringWithRange:NSMakeRange(from, self.length - from)];
}

/// 删除第一个字符
- (NSString *)zhh_removeFirstCharacter {
    return [self zhh_safeSubstringToIndex:1];
}

/// 删除最后一个字符
- (NSString *)zhh_removeLastCharacter {
    return [self zhh_safeSubstringToIndex:self.length - 1];
}

/// @brief  根据文件 URL 的后缀返回对应的 MIMEType
/// @return mimeType，若找不到对应类型，则默认为 application/octet-stream
- (NSString *)zhh_mimeType {
    // 通过当前文件路径的后缀名获取 MIME 类型
    return [self zhh_mimeTypeForExtension:[self pathExtension]];
}

/// @brief  根据文件后缀名返回对应的 mimeType
/// @param  extension 文件后缀名
/// @return mimeType 字符串，默认为 application/octet-stream
- (NSString *)zhh_mimeTypeForExtension:(NSString *)extension {
    // 从 MIME 字典中查找对应的 MIME 类型
    return [[self zhh_mimeDict] valueForKey:[extension lowercaseString]] ?: @"application/octet-stream";
}
/**
 *  @brief  常见 MIME 类型集合
 *
 *  @return 包含常见 MIME 类型的字典，键为文件后缀名，值为对应 MIME 类型
 */
- (NSDictionary *)zhh_mimeDict {
    static NSDictionary *MIMEDict = nil;
    static dispatch_once_t onceToken;
    // 使用 dispatch_once 确保字典只加载一次（懒加载）
    dispatch_once(&onceToken, ^{
        MIMEDict = @{
            @"":        @"application/octet-stream", // 默认类型
            @"323":     @"text/h323",
            @"acx":     @"application/internet-property-stream",
            @"ai":      @"application/postscript",
            @"aif":     @"audio/x-aiff",
            @"aifc":    @"audio/x-aiff",
            @"aiff":    @"audio/x-aiff",
            @"asf":     @"video/x-ms-asf",
            @"asr":     @"video/x-ms-asf",
            @"asx":     @"video/x-ms-asf",
            @"au":      @"audio/basic",
            @"avi":     @"video/x-msvideo",
            @"axs":     @"application/olescript",
            @"bas":     @"text/plain",
            @"bcpio":   @"application/x-bcpio",
            @"bin":     @"application/octet-stream",
            @"bmp":     @"image/bmp",
            @"c":       @"text/plain",
            @"cat":     @"application/vnd.ms-pkiseccat",
            @"cdf":     @"application/x-cdf",
            @"cer":     @"application/x-x509-ca-cert",
            @"class":   @"application/octet-stream",
            @"clp":     @"application/x-msclip",
            @"cmx":     @"image/x-cmx",
            @"cod":     @"image/cis-cod",
            @"cpio":    @"application/x-cpio",
            @"crd":     @"application/x-mscardfile",
            @"crl":     @"application/pkix-crl",
            @"crt":     @"application/x-x509-ca-cert",
            @"csh":     @"application/x-csh",
            @"css":     @"text/css",
            @"dcr":     @"application/x-director",
            @"der":     @"application/x-x509-ca-cert",
            @"dir":     @"application/x-director",
            @"dll":     @"application/x-msdownload",
            @"dms":     @"application/octet-stream",
            @"doc":     @"application/msword",
            @"docx":    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            @"dot":     @"application/msword",
            @"dvi":     @"application/x-dvi",
            @"dxr":     @"application/x-director",
            @"eps":     @"application/postscript",
            @"etx":     @"text/x-setext",
            @"evy":     @"application/envoy",
            @"exe":     @"application/octet-stream",
            @"fif":     @"application/fractals",
            @"flr":     @"x-world/x-vrml",
            @"gif":     @"image/gif",
            @"gtar":    @"application/x-gtar",
            @"gz":      @"application/x-gzip",
            @"h":       @"text/plain",
            @"hdf":     @"application/x-hdf",
            @"hlp":     @"application/winhlp",
            @"hqx":     @"application/mac-binhex40",
            @"hta":     @"application/hta",
            @"htc":     @"text/x-component",
            @"htm":     @"text/html",
            @"html":    @"text/html",
            @"ico":     @"image/x-icon",
            @"ief":     @"image/ief",
            @"iii":     @"application/x-iphone",
            @"ins":     @"application/x-internet-signup",
            @"isp":     @"application/x-internet-signup",
            @"jfif":    @"image/pipeg",
            @"jpe":     @"image/jpeg",
            @"jpeg":    @"image/jpeg",
            @"jpg":     @"image/jpeg",
            @"js":      @"application/x-javascript",
            @"json":    @"application/json", // 常见 JSON 类型
            @"latex":   @"application/x-latex",
            @"lha":     @"application/octet-stream",
            @"lsf":     @"video/x-la-asf",
            @"lsx":     @"video/x-la-asf",
            @"lzh":     @"application/octet-stream",
            @"m":       @"text/plain",
            @"m13":     @"application/x-msmediaview",
            @"m14":     @"application/x-msmediaview",
            @"m3u":     @"audio/x-mpegurl",
            @"man":     @"application/x-troff-man",
            @"mdb":     @"application/x-msaccess",
            @"me":      @"application/x-troff-me",
            @"mht":     @"message/rfc822",
            @"mhtml":   @"message/rfc822",
            @"mid":     @"audio/mid",
            @"mov":     @"video/quicktime",
            @"mp3":     @"audio/mpeg",
            @"mp4":     @"video/mp4",
            @"png":     @"image/png",
            @"pdf":     @"application/pdf",
            @"ppt":     @"application/vnd.ms-powerpoint",
            @"pptx":    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
            @"rtf":     @"application/rtf",
            @"svg":     @"image/svg+xml",
            @"txt":     @"text/plain",
            @"wav":     @"audio/x-wav",
            @"xls":     @"application/vnd.ms-excel",
            @"xlsx":    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            @"xml":     @"text/xml",
            @"zip":     @"application/zip"
        };
    });
    return MIMEDict;
}
@end
