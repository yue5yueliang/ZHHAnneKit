//
//  UITextField+ZHHExtend.m
//  ZHHAnneKitExample
//
//  Created by 桃色三岁 on 2022/8/3.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "UITextField+ZHHExtend.h"
#import <objc/runtime.h>

@implementation UITextField (ZHHExtend)
static char placeholderColorKey,placeHolderFontSizeKey;
- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, &placeholderColorKey);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    objc_setAssociatedObject(self, &placeholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) [self zhh_setPlaceholder];
}
- (CGFloat)placeholderFontSize{
    return [objc_getAssociatedObject(self, &placeHolderFontSizeKey) floatValue];
}
- (void)setPlaceholderFontSize:(CGFloat)placeHolderFontSize{
    objc_setAssociatedObject(self, &placeHolderFontSizeKey, @(placeHolderFontSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.placeholder) [self zhh_setPlaceholder];
}
- (void)zhh_setPlaceholder{
    UIColor *color = objc_getAssociatedObject(self, &placeholderColorKey);
    CGFloat size = [objc_getAssociatedObject(self, &placeHolderFontSizeKey) floatValue];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (color) {
        [dict setValue:color forKey:NSForegroundColorAttributeName];
    }
    if (size) {
        [dict setValue:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    }
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
}

- (NSInteger)maxLength{
    return [objc_getAssociatedObject(self, @selector(maxLength)) integerValue];
}
- (void)setMaxLength:(NSInteger)maxLength{
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(zhh_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (BOOL)securePasswords{
    return [objc_getAssociatedObject(self, @selector(securePasswords)) boolValue];
}
- (void)setSecurePasswords:(BOOL)securePasswords{
    objc_setAssociatedObject(self, @selector(securePasswords), @(securePasswords), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSString *temp = self.text;
    self.text = @"";
    self.secureTextEntry = securePasswords;
    self.text = temp;
}

@dynamic displayInputAccessoryView;
- (void)setDisplayInputAccessoryView:(BOOL)displayInputAccessoryView{
    if (!displayInputAccessoryView) {
        self.inputAccessoryView = [UIView new];
    }
}
- (void (^)(NSString * _Nonnull))kMaxLengthBolck{
    return objc_getAssociatedObject(self, @selector(kMaxLengthBolck));
}
- (void)setKMaxLengthBolck:(void (^)(NSString * _Nonnull))kMaxLengthBolck{
    objc_setAssociatedObject(self, @selector(kMaxLengthBolck), kMaxLengthBolck, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(NSString * _Nonnull))kTextEditingChangedBolck{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setKTextEditingChangedBolck:(void (^)(NSString * _Nonnull))kTextEditingChangedBolck{
    objc_setAssociatedObject(self, @selector(kTextEditingChangedBolck), kTextEditingChangedBolck, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(zhh_textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

/// Maximum character length reached
- (void)maxLengthWithBlock:(void(^)(NSString * text))withBlock{
    self.kMaxLengthBolck = withBlock;
}

/// Text editing moment
- (void)textEditingChangedWithBolck:(void(^)(NSString * text))withBlock{
    self.kTextEditingChangedBolck = withBlock;
}

/// 最大输入限制
- (void)zhh_textFieldChanged:(UITextField *)textField{
    if (self.kTextEditingChangedBolck) {
        self.kTextEditingChangedBolck(textField.text);
    }
    if (textField.maxLength <= 0) return;
    UITextPosition *position = [self positionFromPosition:[self markedTextRange].start offset:0];
    if (position == nil && textField.text.length > textField.maxLength) {
        textField.text = [self.text substringToIndex:self.maxLength];
        if (self.kMaxLengthBolck) {
            self.kMaxLengthBolck(textField.text);
        }
    }
}
@end
