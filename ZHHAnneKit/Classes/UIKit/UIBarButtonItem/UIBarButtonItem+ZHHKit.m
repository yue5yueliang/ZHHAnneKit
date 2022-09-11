//
//  UIBarButtonItem+ZHHKit.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/9/8.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UIBarButtonItem+ZHHKit.h"
#import "UIColor+ZHHKit.h"
#import "UIImage+ZHHKit.h"
#import "UIView+Frame.h"

@implementation UIBarButtonItem (ZHHKit)
+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName highImageName:(NSString *_Nullable)highImageName target:(id)target action:(SEL)action {
     
    UIButton *button = [[UIButton alloc] init];

    if(imageName) [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if(highImageName) [button setImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 100, 44);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

+ (UIBarButtonItem *)zhh_itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [UIBarButtonItem zhh_itemWithImageName:imageName highImageName:nil target:target action:action];
}

+ (UIBarButtonItem *)zhh_systemItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                                    textType:(BOOL)textType {
    UIBarButtonItem *item = textType ?
    ({
        /// 设置普通状态的文字属性
        item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
        titleColor = titleColor?titleColor:[UIColor zhh_colorWithHex:0x181818];
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = titleColor;
        textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15.f];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset =  CGSizeZero;
        textAttrs[NSShadowAttributeName] = shadow;
        [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
        
        // 设置高亮状态的文字属性
        NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
        highTextAttrs[NSForegroundColorAttributeName] = [titleColor colorWithAlphaComponent:.5f];
        [item setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
        
        // 设置不可用状态(disable)的文字属性
        NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
        disableTextAttrs[NSForegroundColorAttributeName] = [titleColor colorWithAlphaComponent:.5f];
        [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
        
        item;
    }) : ({
        item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:target action:selector];
        item;
    });
    return item;
}

+ (UIBarButtonItem *)zhh_customItemWithTitle:(NSString *)title
                                  titleColor:(UIColor *_Nullable)titleColor
                                   imageName:(NSString *)imageName
                                      target:(id)target
                                    selector:(SEL)selector
                  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment{
    UIButton *item = [[UIButton alloc] init];
    titleColor = titleColor?titleColor:[UIColor whiteColor];
    if (title.length > 0) {
        [item setTitle:title forState:UIControlStateNormal];
    }
    
    if (imageName.length > 0) {
        [item setImage:[UIImage zhh_imageAlwaysOriginalImageWithImageName:imageName] forState:UIControlStateNormal];
    }
    [item.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [item setTitleColor:titleColor forState:UIControlStateNormal];
    [item setTitleColor:[titleColor colorWithAlphaComponent:.5f] forState:UIControlStateHighlighted];
    [item setTitleColor:[titleColor colorWithAlphaComponent:.5f] forState:UIControlStateDisabled];
    [item sizeToFit];
    item.zhh_size = CGSizeMake(44, 44);
    item.contentHorizontalAlignment = contentHorizontalAlignment;
    [item addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:item];
}


/// 返回按钮 带箭头的
+ (UIBarButtonItem *)zhh_backItemWithTitle:(NSString *)title
                                 imageName:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action
{
    return [self zhh_customItemWithTitle:title titleColor:nil imageName:imageName target:target selector:action contentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
}
@end
