//
//  UIImage+ZHHNameImage.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/18.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UIImage+ZHHNameImage.h"
#import "UIColor+ZHHHex.h"
#import "UIImage+ZHHColor.h"

@implementation UIImage (ZHHNameImage)
+ (UIImage *)zhh_createTextImageWithString:(NSString *)string imageSize:(CGSize)size {
    return [UIImage zhh_createNicknameImageName:[UIImage zhh_dealWithNikeName:string] imageSize:size];
}

// 按规则截取nikeName
+ (NSString *)zhh_dealWithNikeName:(NSString *)nikeName {
    // 筛除部分特殊符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"【】"];
    nikeName = [nikeName stringByTrimmingCharactersInSet:set];
    NSString *showName = @"";
    NSString *tempName = @"";
    
    NSRange range1 = [nikeName rangeOfString:@"-"];
    
    if (range1.length) {
        // 含有“-”
        tempName = [nikeName substringToIndex:range1.location];
    } else {
        // 不含“-”
        tempName = nikeName;
    }
    
    NSRange range2 = [tempName rangeOfString:@"("];
    
    if (range2.length) {
        // 含有“(”
        tempName = [tempName substringToIndex:range2.location];
    } else {
        // 不含“(”
        tempName = tempName;
    }
    
    if ([UIImage zhh_isStringContainLetterWith:tempName]) {
        // 含有字母取前两个
        showName = [tempName substringToIndex:2];
    } else {
        // 不含字母
        if (!tempName.length) {
            
        } else if (tempName.length == 1) {
            showName = [tempName substringToIndex:1];
        } else if (tempName.length == 2) {
            showName = [tempName substringToIndex:2];
        } else if (tempName.length == 3) {
            showName = [tempName substringFromIndex:1];
        } else if (tempName.length == 4) {
            showName = [tempName substringFromIndex:2];
        } else {
            showName = [tempName substringToIndex:2];
        }
    }
    return showName;
}

// 检查是否含有字母
+ (BOOL)zhh_isStringContainLetterWith:(NSString *)str {
    if (!str) {
        return NO;
    }
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

// 根据nickname绘制图片
+ (UIImage *)zhh_createNicknameImageName:(NSString *)name imageSize:(CGSize)size{
    NSArray *colorArr = @[@"17c295",@"b38979",@"f2725e",@"f7b55e",@"4da9eb",@"5f70a7",@"568aad"];
    NSString *nickname = colorArr[ABS(name.hash % colorArr.count)];
    UIImage *image = [UIImage zhh_imageWithColor:[UIImage zhh_colorWithHexString:nickname alpha:1.0] size:size cornerRadius:size.width/2];
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画名字
    UIFont *fontSize = [UIFont systemFontOfSize:15.f];
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName:fontSize}];
    
    [name drawAtPoint:CGPointMake((size.width  - nameSize.width)/2, (size.height - nameSize.height)/2)
       withAttributes:@{NSFontAttributeName:fontSize, NSForegroundColorAttributeName:[UIColor zhh_colorWithHex:0xffffff]}];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

+ (id)zhh_colorWithHexString:(NSString*)hexColor alpha:(CGFloat)alpha {
    
    unsigned int red,green,blue;
    NSRange range;
    
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor* retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
    return retColor;
}
@end
