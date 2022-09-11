//
//  UILabel+TextTapAction.m
//  ZHHAnneKitExample
//
//  Created by 宁小陌 on 2022/8/2.
//  Copyright © 2022 宁小陌y. All rights reserved.
//

#import "UILabel+TextTapAction.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@interface ZHHAttributeTapModel : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic) NSRange range;

@end

@implementation ZHHAttributeTapModel

@end


@implementation UILabel (TextTapAction)
- (void)zhh_addAttributeTapActionWithStrings:(NSArray<NSString *> *)strings withBlock:(ZHHLabelTapBlock)withBlock{
    [self zhh_removeAttributeTapActions];
    [self zhh_getRangesWithStrings:strings];
    self.userInteractionEnabled = YES;
    if (self.tapBlock != withBlock) {
        self.tapBlock = withBlock;
    }
}

- (void)zhh_addAttributeTapActionWithRanges:(NSArray<NSString *> *)ranges withBlock:(ZHHLabelTapBlock)withBlock{
    [self zhh_removeAttributeTapActions];
    [self zhh_getRangesWithRanges:ranges];
    self.userInteractionEnabled = YES;
    if (self.tapBlock != withBlock) {
        self.tapBlock = withBlock;
    }
}

- (void)zhh_removeAttributeTapActions{
    self.tapBlock = nil;
    self.effectDic = nil;
    self.isTapAction = NO;
    self.attributeStrings = [NSMutableArray array];
}

#pragma mark - touchAction

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTapAction) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    if (objc_getAssociatedObject(self, @selector(zhh_openTap))) {
        self.isTapEffect = self.zhh_openTap;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    if (![self zhh_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.isTapEffect) {
            [weakSelf zhh_saveEffectDicWithRange:range];
            [weakSelf zhh_tapEffectWithStatus:YES];
        }
    }]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTapAction) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(zhh_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    if (![self zhh_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
    }]) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.isTapAction) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    if (self.isTapEffect) {
        [self performSelectorOnMainThread:@selector(zhh_tapEffectWithStatus:) withObject:nil waitUntilDone:NO];
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak typeof(self) weakSelf = self;
    if (![self zhh_getTapFrameWithTouchPoint:point result:^(NSString *string, NSRange range, NSInteger index) {
        if (weakSelf.tapBlock) {
            weakSelf.tapBlock (weakSelf, string, range, index);
        }
    }]) {
        [super touchesCancelled:touches withEvent:event];
    }
}

#pragma mark - method

/// 获取点击位置
/// @param point 点击坐标
/// @param resultBlock 事件响应
- (BOOL)zhh_getTapFrameWithTouchPoint:(CGPoint)point result:(void(^)(NSString *, NSRange, NSInteger))resultBlock{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    CGMutablePathRef Path = CGPathCreateMutable();
    CGPathAddRect(Path, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height + 20));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    CFArrayRef lines = CTFrameGetLines(frame);
    CGFloat total_height = [self zhh_textSizeWithAttributedString:self.attributedText
                                                           width:self.bounds.size.width
                                                   numberOfLines:0].height;
    if (!lines) {
        CFRelease(frame);
        CFRelease(framesetter);
        CGPathRelease(Path);
        return NO;
    }
    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f);
    for (CFIndex i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self zhh_getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        CGFloat lineOutSpace = (self.bounds.size.height - total_height) / 2;
        rect.origin.y = lineOutSpace + [self zhh_getLineOrign:line];
        if (self.zhh_enlargeTapArea) {
            rect.origin.y -= 5;
            rect.size.height += 10;
        }
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect), point.y - CGRectGetMinY(rect));
            CFIndex index = CTLineGetStringIndexForPosition(line, relativePoint);
            CGFloat offset;
            CTLineGetOffsetForStringIndex(line, index, &offset);
            if (offset > relativePoint.x) {
                index = index - 1;
            }
            NSInteger link_count = self.attributeStrings.count;
            for (int k = 0; k < link_count; k++) {
                ZHHAttributeTapModel *model = self.attributeStrings[k];
                NSRange link_range = model.range;
                if (NSLocationInRange(index, link_range)) {
                    if (resultBlock) {
                        resultBlock (model.string , model.range , (NSInteger)k);
                    }
                    CFRelease(frame);
                    CFRelease(framesetter);
                    CGPathRelease(Path);
                    return YES;
                }
            }
        }
    }
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(Path);
    return NO;
}

- (CGRect)zhh_getLineBounds:(CTLineRef)line point:(CGPoint)point{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = 0.0f;
    CFRange range = CTLineGetStringRange(line);
    NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
    if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
        attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
    }
    height = [self zhh_textSizeWithAttributedString:attributedString width:self.bounds.size.width numberOfLines:0].height;
    return CGRectMake(point.x, point.y , width, height);
}

- (CGFloat)zhh_getLineOrign:(CTLineRef)line{
    CFRange range = CTLineGetStringRange(line);
    if (range.location == 0) {
        return 0.;
    }else {
        NSAttributedString * attributedString = [self.attributedText attributedSubstringFromRange:NSMakeRange(0, range.location)];
        if ([attributedString.string hasSuffix:@"\n"] && attributedString.string.length > 1) {
            attributedString = [attributedString attributedSubstringFromRange:NSMakeRange(0, attributedString.length - 1)];
        }
        return [self zhh_textSizeWithAttributedString:attributedString
                                               width:self.bounds.size.width
                                       numberOfLines:0].height;
    }
}

- (CGSize)zhh_textSizeWithAttributedString:(NSAttributedString *)attributedString
                                    width:(float)width
                            numberOfLines:(NSInteger)numberOfLines{
    @autoreleasepool {
        UILabel *sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        sizeLabel.numberOfLines = numberOfLines;
        sizeLabel.attributedText = attributedString;
        CGSize fitSize = [sizeLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)];
        return fitSize;
    }
}

/// 扩大点击域
- (void)zhh_tapEffectWithStatus:(BOOL)status{
    if (self.isTapEffect) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        NSMutableAttributedString *subAtt = [[NSMutableAttributedString alloc] initWithAttributedString:[[self.effectDic allValues] firstObject]];
        NSRange range = NSRangeFromString([[self.effectDic allKeys] firstObject]);
        if (status) {
            [subAtt addAttribute:NSBackgroundColorAttributeName
                           value:self.zhh_highlightColor
                           range:NSMakeRange(0, subAtt.string.length)];
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        } else {
            [attStr replaceCharactersInRange:range withAttributedString:subAtt];
        }
        self.attributedText = attStr;
    }
}

- (void)zhh_saveEffectDicWithRange:(NSRange)range{
    self.effectDic = [NSMutableDictionary dictionary];
    NSAttributedString *subAttribute = [self.attributedText attributedSubstringFromRange:range];
    [self.effectDic setObject:subAttribute forKey:NSStringFromRange(range)];
}

- (void)zhh_getRangesWithStrings:(NSArray<NSString *>  *)strings{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [totalStr rangeOfString:obj];
        if (range.length != 0) {
            totalStr = [totalStr stringByReplacingCharactersInRange:range
                                                         withString:[weakSelf zhh_getStringWithRange:range]];
            ZHHAttributeTapModel *model = [[ZHHAttributeTapModel alloc] init];
            model.range = range;
            model.string = obj;
            [weakSelf.attributeStrings addObject:model];
        }
    }];
}

- (void)zhh_getRangesWithRanges:(NSArray<NSString *> *)ranges{
    if (self.attributedText == nil) {
        self.isTapAction = NO;
        return;
    }
    self.isTapAction = YES;
    self.isTapEffect = YES;
    __block  NSString *totalStr = self.attributedText.string;
    self.attributeStrings = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [ranges enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSRange range = NSRangeFromString(obj);
        NSAssert(totalStr.length >= range.location + range.length, @"NSRange(%ld,%ld) is out of bounds",range.location,range.length);
        NSString * string = [totalStr substringWithRange:range];
        ZHHAttributeTapModel *model = [ZHHAttributeTapModel new];
        model.range = range;
        model.string = string;
        [weakSelf.attributeStrings addObject:model];
    }];
}

- (NSString *)zhh_getStringWithRange:(NSRange)range{
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < range.length ; i++) {
        [string appendString:@" "];
    }
    return string;
}

#pragma mark - kvo

- (void)zhh_addObserver{
    [self addObserver:self forKeyPath:@"attributedText"
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:nil];
}

- (void)zhh_removeObserver{
    id info = self.observationInfo;
    NSString * key = @"attributedText";
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            [self removeObserver:self forKeyPath:@"attributedText" context:nil];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:@"attributedText"]) {
        if (self.isTapAction) {
            if (![change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]) {
               
            }
        }
    }
}

#pragma mark - associated

- (NSMutableArray *)attributeStrings{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setAttributeStrings:(NSMutableArray *)attributeStrings{
    objc_setAssociatedObject(self, @selector(attributeStrings), attributeStrings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)effectDic{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setEffectDic:(NSMutableDictionary *)effectDic{
    objc_setAssociatedObject(self, @selector(effectDic), effectDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapAction{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsTapAction:(BOOL)isTapAction{
    objc_setAssociatedObject(self, @selector(isTapAction), @(isTapAction), OBJC_ASSOCIATION_ASSIGN);
}

- (ZHHLabelTapBlock)tapBlock{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTapBlock:(ZHHLabelTapBlock)tapBlock{
    objc_setAssociatedObject(self, @selector(tapBlock), tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (BOOL)zhh_openTap{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZhh_openTap:(BOOL)zhh_openTap{
    objc_setAssociatedObject(self, @selector(zhh_openTap), @(zhh_openTap), OBJC_ASSOCIATION_ASSIGN);
    self.isTapEffect = zhh_openTap;
}

- (BOOL)zhh_enlargeTapArea{
    NSNumber * number = objc_getAssociatedObject(self, _cmd);
    if (number == nil) {
        number = @(YES);
        objc_setAssociatedObject(self, _cmd, number, OBJC_ASSOCIATION_ASSIGN);
    }
    return [number boolValue];
}
- (void)setZhh_enlargeTapArea:(BOOL)zhh_enlargeTapArea{
    objc_setAssociatedObject(self, @selector(zhh_enlargeTapArea), @(zhh_enlargeTapArea), OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)zhh_highlightColor{
    UIColor * color = objc_getAssociatedObject(self, _cmd);
    if (color == nil) {
        color = [UIColor redColor];
        objc_setAssociatedObject(self, _cmd, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setZhh_highlightColor:(UIColor *)zhh_highlightColor{
    objc_setAssociatedObject(self, @selector(zhh_highlightColor), zhh_highlightColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isTapEffect{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setIsTapEffect:(BOOL)isTapEffect{
    objc_setAssociatedObject(self, @selector(isTapEffect), @(isTapEffect), OBJC_ASSOCIATION_ASSIGN);
}
@end
