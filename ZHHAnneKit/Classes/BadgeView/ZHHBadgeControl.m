//
//  ZHHBadgeControl.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/9/14.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHBadgeControl.h"
#import "UIView+ZHHBadgeView.h"

@interface ZHHBadgeControl ()
/// 显示文本内容的标签
@property (nonatomic, strong) UILabel *textLabel;
/// 显示背景图片的视图
@property (nonatomic, strong) UIImageView *imageView;
/// Badge 的背景颜色
@property (nonatomic, strong) UIColor *badgeViewColor;
/// Badge 高度的约束，用于动态调整高度
@property (nonatomic, strong) NSLayoutConstraint *badgeViewHeightConstraint;
/// Badge 宽度的约束，用于动态调整宽度
@property (nonatomic, strong) NSLayoutConstraint *badgeViewWidthConstraint;
@end

@implementation ZHHBadgeControl

+ (instancetype)defaultBadge {
    // 创建一个默认的 Badge 实例
    return [[self alloc] initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews]; // 初始化子视图
    }
    return self;
}

- (void)setupSubviews {
    // 设置圆角、背景颜色及初始状态
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 9.0;
    self.backgroundColor = UIColor.redColor;
    self.flexMode = ZHHBadgeViewFlexModeTail;

    // 禁用 Autoresizing Mask，使用 Auto Layout
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    // 设置布局优先级，保证布局稳定性
    [self setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:251 forAxis:UILayoutConstraintAxisVertical];

    // 添加子视图
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];

    // 添加布局约束
    [self addLayoutWith:self.imageView leading:0 trailing:0];
    [self addLayoutWith:self.textLabel leading:5 trailing:-5];
}

- (void)addLayoutWith:(UIView *)view leading:(CGFloat)leading trailing:(CGFloat)trailing {
    // 为子视图添加顶部、底部、前后间距约束
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:leading];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:trailing];
    
    // 设置优先级
    leadingConstraint.priority = 999;
    trailingConstraint.priority = 999;

    // 添加约束到当前视图
    [self addConstraints:@[topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]];
}

#pragma mark - Setter-Getter

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text; // 更新文本内容
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    self.textLabel.attributedText = attributedText; // 更新富文本内容
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.textLabel.font = font; // 更新字体
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.imageView.image = backgroundImage; // 更新背景图片
    
    if (backgroundImage) {
        // 有背景图片时移除高度约束，设置透明背景
        if (self.badgeViewHeightConstraint) {
            [self removeConstraint:self.badgeViewHeightConstraint];
        }
        self.backgroundColor = UIColor.clearColor;
    } else {
        // 没有背景图片时恢复高度约束，设置背景颜色
        if (self.badgeViewHeightConstraint) {
            [self addConstraint:self.badgeViewHeightConstraint];
        }
        self.backgroundColor = self.badgeViewColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    // 保存非透明背景颜色，用于恢复
    if (backgroundColor && backgroundColor != UIColor.clearColor) {
        self.badgeViewColor = backgroundColor;
    }
}

#pragma mark - Lazy
- (UILabel *)textLabel {
    if (!_textLabel) {
        // 懒加载文本标签
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        // 懒加载图片视图
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
