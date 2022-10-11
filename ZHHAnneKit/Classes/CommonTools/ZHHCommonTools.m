//
//  ZHHCommonTools.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/22.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHCommonTools.h"

@implementation ZHHCommonTools
static CGFloat pixelOne = -1.0f;
+ (CGFloat)zhh_pixelOne {
    if (pixelOne < 0) {
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    }
    return pixelOne;
}

+ (NSString *)zhh_random16Text{
    NSString *str = [NSString string];
    //16位
    for (int i = 0; i < 16; i++){
        //随机出现字母、数字
        switch(arc4random() % 3) {
            case 0:
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",arc4random() % 10]];
                break;
            case 1:
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",arc4random() % 26 + 97]];
                break;
            case 2:
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%d",arc4random() % 26 + 65]];
                break;
        }
    }
    return str;
}

/** 随机数生成 */
+ (NSInteger)zhh_randomNumber:(NSInteger)from to:(NSInteger)to{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

/** 表情符号的判断 */
+ (BOOL)zhh_stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

#pragma mark ------------ json或字符串的解析 ----------------------------
/** json格式字典转字符串格式 */
+ (NSString *)zhh_jsonTextWithJSONObject:(NSDictionary *)object{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/** json格式数组转为 字符串*/
+ (NSString *)zhh_jsonTextWithJSONArray:(NSArray *)jsonArray{
    NSData *data = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //去除空格和回车：
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonStr;
}
/** 字符串格式转json */
+ (id)zhh_jsonObjectWithJSONText:(NSString *)jsonText{
    if (jsonText.length == 0) {
        NSLog(@"需要解析json字符串不能为空");
        return nil;
    }
    NSData *jsonData = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err){
        NSLog(@"解析活动json解析失败：%@",err);
        return nil;
    }
    return json;
}

#pragma mark ------------ 字符串相关格式处理 ----------------------------
/** 以逗号隔开每三位数 */
+ (NSString *)zhh_separatorNumberByComma:(NSInteger)number{
    //提取正数部分
    BOOL negative = number < 0;
    NSInteger num = labs(number);
    NSString *numStr = [NSString stringWithFormat:@"%ld",(long)num];
    
    //根据数据长度判断所需逗号个数
    NSInteger length = numStr.length;
    NSInteger count = numStr.length / 3;
    
    //在适合的位置插入逗号
    for (int i=1; i<=count; i++) {
        NSInteger location = length - i * 3;
        if (location <= 0) break;
        //插入逗号拆分数据
        numStr = [numStr stringByReplacingCharactersInRange:NSMakeRange(location, 0) withString:@","];
    }
    
    //别忘给负数加上符号
    if (negative) {
        numStr = [NSString stringWithFormat:@"-%@",numStr];
    }
    return numStr;
}

/** 如银行卡字符串格式化 每四位一个空格*/
+ (NSString *)zhh_bankcardNumberFormat:(NSString *)textContent{
    textContent = [textContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newString = @"";
    while (textContent.length > 0) {
        NSString *subString = [textContent substringToIndex:MIN(textContent.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        textContent = [textContent substringFromIndex:MIN(textContent.length, 4)];
    }
    return newString;
}

/**
 *   把身份证和手机号中间替换成星号的做法
 *
 *   @param replaceText 当前文字
 *   @param index       开始索引
 *   @param length      星号个数
 *   @return 返回已经处理的文字
 */
+ (NSString *)zhh_replaceAsteriskWithText:(NSString *)replaceText index:(NSInteger)index length:(NSInteger)length{
    NSString *replaceStr = replaceText;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(index, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        index ++;
    }
    return replaceStr;
}

/** 处理空字符串为空的显示 */
+ (NSString *)zhh_showTextNull:(NSString *)parameter{
    //（null）判断方法
    if (parameter == nil) return @"";
    // <null>判断方法
    if([parameter isEqual:[NSNull null]]) return @"";
    // "<null>"判断方法
    if([parameter isEqualToString:@"<null>"]) return @"";
    // ""判断方法
    if(parameter.length == 0) return @"";
    return parameter;
}

/** 对字典(Key-Value)排序 不区分大小写 */
+ (NSString *)zhh_sortedDictionaryByCaseConversion:(NSMutableDictionary *)dictionary{
    //将所有的key放进数组
    NSArray *allKeyArray = [dictionary allKeys];
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        /**
         In the compare: methods, the range argument specifies the
         subrange, rather than the whole, of the receiver to use in the
         comparison. The range is not applied to the search string.  For
         example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)]
         compares "A" to "ABC", not "A" to "A", and will return
         NSOrderedAscending. It is an error to specify a range that is
         outside of the receiver's bounds, and an exception may be raised.
         
         - (NSComparisonResult)compare:(NSString *)string;
         
         compare方法的比较原理为,依次比较当前字符串的第一个字母:
         如果不同,按照输出排序结果
         如果相同,依次比较当前字符串的下一个字母(这里是第二个)
         以此类推
         
         排序结果
         NSComparisonResult resuest = [obj1 compare:obj2];为从小到大,即升序;
         NSComparisonResult resuest = [obj2 compare:obj1];为从大到小,即降序;
         
         注意:compare方法是区分大小写的,即按照ASCII排序
         */
        //小写转化：lowercaseString 大写转换：uppercaseString
        obj1 = [obj1 uppercaseString];
        obj2 = [obj2 uppercaseString];
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //    NXMUILog(@"Sort After Key Array:%@",afterSortKeyArray);
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    NSString *signString = @"";
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dictionary objectForKey:sortsing];
        [valueArray addObject:valueString];
        NSString *k_v = [NSString stringWithFormat:@"%@=%@&",sortsing,valueString];
        signString = [signString stringByAppendingString:k_v];
        
    }
    signString = [signString stringByAppendingString:@"-"];
    /// 分割
    NSArray *segmentationArray = [signString componentsSeparatedByString:@"&-"];
//    NSString *segmentationAfterstr = [segmentationArray[0] uppercaseString];
    NSString *segmentationAfterstr = segmentationArray[0];
    NSLog(@"大小写转换str --- - %@",segmentationAfterstr);
    return segmentationAfterstr;
}

/**
 *  字符串转星期几
 *
 *  @param currentDate 当前日期(2019-04-30)
 *  @return 返回星期-到星期天中的某一天
 */
+ (NSString *)zhh_weekdayStringFromDate:(NSString*)currentDate{
    // 实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];
    // 设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate*inputDate =[dateFormat dateFromString:currentDate];
    
    
    NSArray *weekdays = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)zhh_dateWeekWithDateString:(NSString *)dateString{
    NSTimeInterval time = [dateString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    NSInteger _weekday = [weekdayComponents weekday];
    NSString *weekStr;
    if (_weekday == 1) {
        weekStr = @"星期日";
    }else if (_weekday == 2){
        weekStr = @"星期一";
    }else if (_weekday == 3){
        weekStr = @"星期二";
    }else if (_weekday == 4){
        weekStr = @"星期三";
    }else if (_weekday == 5){
        weekStr = @"星期四";
    }else if (_weekday == 6){
        weekStr = @"星期五";
    }else if (_weekday == 7){
        weekStr = @"星期六";
    }
    return weekStr;
}

#pragma mark ------------ 富文本相关的处理 ----------------------------
/**
 *  通过富文本添加图标
 *  @param textStr  当前文字
 *  @param imageArr 需要设置的图标
 *  @param span     间距
 *  @param font     字体
 *  @return 返回已经设置好的富文本
 */
+ (NSAttributedString *)zhh_imageWithText:(NSString *)textStr imageArr:(NSArray<UIImage *> *)imageArr span:(CGFloat)span font:(UIFont *)font{
    NSMutableAttributedString *mutableAttr = [[NSMutableAttributedString alloc] init];
    for (UIImage *img in imageArr) {//遍历添加标签
        // NSTextAttachment可以将图片转换为富文本内容
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = img;
        //计算图片大小，与文字同高，按比例设置宽度
        CGFloat imgH = font.pointSize;
        CGFloat imgW = (img.size.width / img.size.height) * imgH;
        //计算文字padding-top ，使图片垂直居中
        CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
//        attach.bounds = CGRectMake(0, -textPaddingTop , img.size.width, img.size.height);
        attach.bounds = CGRectMake(0, -textPaddingTop , imgW, imgH);
        
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attach];
        [mutableAttr appendAttributedString:imageAttr];
        //标签后添加空格
        [mutableAttr appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    
    //设置显示文本
    [mutableAttr appendAttributedString:[[NSAttributedString alloc]initWithString:textStr]];
    //设置间距
    if (span != 0) {
        [mutableAttr addAttribute:NSKernAttributeName value:@(span)
                            range:NSMakeRange(0, imageArr.count * 2/*由于图片也会占用一个单位长度,所以带上空格数量，需要 *2 */)];
    }
    return [mutableAttr copy];
}
/**
 *  替换文本字符串
 *
 *  @param currentText 当前的字符串
 *  @param parameter1 需要替换的字符串
 *  @param parameter2 需要替换成的字符串
 */
+ (NSString *)zhh_replaceText:(NSString *)currentText parameter1:(NSString *)parameter1 parameter2:(NSString *)parameter2{
    NSString *replaceText = [currentText stringByReplacingOccurrencesOfString:parameter1 withString:parameter2];
    return replaceText;
}

/**
 *  富文本设置文字颜色
 *
 *  @param color        文字颜色
 *  @param currentText  当前的字符串
 *  @param startIndex   开始下标
 *  @param endIndex     结束下标
 */
+ (NSMutableAttributedString *)zhh_mutableAttributedWithColor:(UIColor *)color currentText:(NSString *)currentText startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:currentText];
    /// 签名文字颜色
    [attributedText addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(startIndex, endIndex)];
    return attributedText;
}

/**
 *  富文本设置文字颜色
 *
 *  @param text 当前的字符串
 *  @param width 需要展示的宽度
 *  @param font 字体
 *  @param lineSpacing 行间距
 */
+ (NSMutableAttributedString *)zhh_setupShowMoreTextLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing{
    //获取文字内容的高度
    CGFloat textHeight = [self zhh_boundingRectWithWidth:width font:font lineSpacing:lineSpacing text:text].height;
    //文字高度超过三行，截取三行的高度，否则有多少显示多少
    if (textHeight > font.lineHeight*3+2*lineSpacing) {
        textHeight = font.lineHeight*3+2*lineSpacing;
    }
    NSMutableAttributedString *mutableAttr = [self zhh_attributedStringWithText:text font:font lineSpacing:lineSpacing];
    return mutableAttr;
}

/**
 *  根据文字内容动态计算UILabel宽高
 *  @param maxWidth label宽度
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+ (CGSize)zhh_boundingRectWithWidth:(CGFloat)maxWidth font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing text:(NSString *)text{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    //#warning 此处设置NSLineBreakByTruncatingTail会导致计算文字高度方法失效
    //    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    //计算文字尺寸
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return size;
}
/**
 *  NSString转换成NSMutableAttributedString
 *  @param text  内容
 *  @param lineSpacing  行间距
 *  @param font  字体
 */
+ (NSMutableAttributedString *)zhh_attributedStringWithText:(NSString *)text font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail]; //截断方式，"abcd..."
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    return attributedStr;
}
/** 解析成html的富文本 */
+ (NSAttributedString *)zhh_attributedStringWithMaxWidth:(CGFloat)maxWidth htmlText:(NSString *)htmlText{
    htmlText = [NSString stringWithFormat:@"<html><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0; \" name=\"viewport\" /><head><style>img{width:%f !important;height:auto}</style></head><body style=\"overflow-wrap:break-word;word-break:break-all;white-space: normal; font-size:15px;color:#515151; \">%@</body></html>",maxWidth,htmlText];
    NSAttributedString *attrStr=  [[NSAttributedString alloc] initWithData:[htmlText dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    /// 前面文字颜色
    return attrStr;
}

#pragma mark ------------ 图片存储相关的处理 ----------------------------
/** 据图片名将图片保存到ImageFile文件夹中 */
+ (NSString *)zhh_imageSavedPath:(NSString *)imageName{
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //获取文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
    //创建ImageFile文件夹
    [fileManager createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    //返回保存图片的路径（图片保存在ImageFile文件夹下）
    NSString * imagePath = [imageDocPath stringByAppendingPathComponent:imageName];
    return imagePath;
    
}

/** 获取当前的windows */
+ (UIWindow *)zhh_currentWindow{
    if([[[UIApplication sharedApplication] delegate] window]){
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        if (window.windowLevel != UIWindowLevelNormal) {
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows) {
                if (tmpWin.windowLevel == UIWindowLevelNormal) {
                    window = tmpWin;
                    break;
                }
            }
        }
        return window;
    }else {
        if (@available(iOS 13.0,*)) {
            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
            //如果是普通APP开发，可以使用
            //SceneDelegate *delegate = (SceneDelegate *)windowScene.delegate;
            //UIWindow *mainWindow = delegate.window;
            
            //  由于在sdk开发中，引入不了SceneDelegate的头文件，所以需要使用kvc获取宿主的app的window
            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow){
                return mainWindow;
            }else{
                return [UIApplication sharedApplication].windows.lastObject;
            }
        }else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
}
/** 获取当前的ViewController */
+ (UIViewController *)zhh_currentVC{
    UIViewController *result = nil;
    UIWindow * window = (UIWindow *)[self zhh_currentWindow];
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}

/** 点击获取验证码 */
+ (void)zhh_startCountDown:(UIButton *)sender{
//    [self.pwdField becomeFirstResponder];
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"重新获取" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
//                [self.codeButton setBackgroundImage:[UIImage zhh_imageWithColor:[UIColor zhh_r:107 zhh_g:152 zhh_b:254]] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                sender.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/*
 * 计算经纬度两者之间的距离
 * @param start 开始的经纬度
 * @param end 结束的经纬度
 */
+ (double)zhh_calculateBetweenDistanceStart:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end{
    double EARTH_RADIUS =6378137;
    double meter =0;
    
    double startLongitude = start.longitude;
    double startLatitude = start.latitude;
    
    double endLongitude = end.longitude;
    double endLatitude = end.latitude;
    
    double radLatitude1 = startLatitude *M_PI/180.0;
    double radLatitude2 = endLatitude *M_PI/180.0;

    double a =fabs(radLatitude1 - radLatitude2);
    double b =fabs(startLongitude *M_PI/180.0- endLongitude *M_PI/180.0);

    double s =2*asin(sqrt(pow(sin(a/2),2) +cos(radLatitude1) *cos(radLatitude2) *pow(sin(b/2),2)));

    s = s * EARTH_RADIUS;
    meter =round(s *10000) /10000;//返回距离单位是米

    return meter;
}

+ (BOOL)zhh_checkLoactionAvailable{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        return true;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        return false;
    }
    return false;
}

+ (void)zhh_regionFlowCallBlock{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if( [[UIApplication sharedApplication]canOpenURL:url] ) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

+ (void)zhh_systemFeedbackGeneratorType:(NSInteger)type {
    if (@available(iOS 10.0, *)) {
        if (type==0) {//轻度点击
            UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [impactLight impactOccurred];
        } else if (type==1){//中度点击
            UIImpactFeedbackGenerator *impactMedium = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
            [impactMedium impactOccurred];
        } else if (type==2){//重度点击
            UIImpactFeedbackGenerator *impactHeavy = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
            [impactHeavy impactOccurred];
        } else if (type==3){//选择切换
            UISelectionFeedbackGenerator *feedbackSelection = [[UISelectionFeedbackGenerator alloc] init];
            [feedbackSelection selectionChanged];
        }
    } else {
        // Fallback on earlier versions
    }
}
@end
