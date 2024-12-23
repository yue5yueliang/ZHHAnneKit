//
//  UIView+ZHHBadgeView.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2024/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHHBadgeControl;

typedef NS_ENUM(NSUInteger, ZHHBadgeViewFlexMode);

#pragma mark - Protocol
@protocol ZHHBadgeView <NSObject>
@required

/// 只读属性，Badge 控件
@property (nonatomic, strong, readonly) ZHHBadgeControl *badgeView;
/// 添加带文本内容的 Badge，默认位置为右上角，背景为红色，高度为 18pts
/// @param text 显示的文本内容
- (void)zhh_addBadgeWithText:(NSString *_Nullable)text;

/// 添加带数字的 Badge，默认位置为右上角，背景为红色，高度为 18pts
/// @param value 显示的数字
- (void)zhh_addBadgeWithValue:(NSInteger)value;

/// 添加带颜色的小圆点，默认位置为右上角，背景为红色，直径为 8pts
/// @param color 圆点的颜色
- (void)zhh_addDotWithColor:(UIColor *)color;

/// 设置 Badge 的高度，宽度会根据高度按比例变化，便于布局调整。
/// 注意：此方法需要在将 Badge 添加到控件上后调用！！！
/// @param height Badge 的高度
- (void)zhh_setBadgeHeight:(CGFloat)height;

/// 设置 Badge 的偏移量，Badge 默认以其父视图的右上角为中心点。
/// @param x X 轴偏移量 (x<0: 向左移动, x>0: 向右移动)
/// @param y Y 轴偏移量 (y<0: 向上移动, y>0: 向下移动)
- (void)zhh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y;

/// 设置 Badge 的伸缩方向
/// ZHHBadgeViewFlexModeHead,    左伸缩 Head Flex    : <==●
/// ZHHBadgeViewFlexModeTail,    右伸缩 Tail Flex    : ●==>
/// ZHHBadgeViewFlexModeMiddle   左右伸缩 Middle Flex : <=●=>
/// @param flexMode 伸缩模式，默认为 ZHHBadgeViewFlexModeTail
- (void)zhh_setBadgeFlexMode:(ZHHBadgeViewFlexMode)flexMode;

/// 显示Badge
- (void)zhh_showBadge;

/// 隐藏Badge
- (void)zhh_hiddenBadge;

/// 数字增加/减少，注意：以下方法仅适用于 Badge 内容为纯数字的情况。
/// 数字加 1
- (void)zhh_incrementBadge;
/// 数字增加指定值
- (void)zhh_incrementBadgeBy:(NSInteger)value;
/// 数字减 1
- (void)zhh_decrementBadge;
/// 数字减少指定值
- (void)zhh_decrementBadgeBy:(NSInteger)value;

@end

@interface UIView (ZHHBadgeView) <ZHHBadgeView>

@end

@interface UIView (Constraint)

/// 获取视图的宽度约束
- (NSLayoutConstraint *)widthConstraint;

/// 获取视图的高度约束
- (NSLayoutConstraint *)heightConstraint;

/// 获取视图与指定视图顶部对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)topConstraintWithItem:(id)item;

/// 获取视图与指定视图前边对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)leadingConstraintWithItem:(id)item;

/// 获取视图与指定视图底部对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)bottomConstraintWithItem:(id)item;

/// 获取视图与指定视图后边对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)trailingConstraintWithItem:(id)item;

/// 获取视图与指定视图水平中心对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)centerXConstraintWithItem:(id)item;

/// 获取视图与指定视图垂直中心对齐的约束
/// @param item 对齐的参考视图
- (NSLayoutConstraint *)centerYConstraintWithItem:(id)item;

@end
NS_ASSUME_NONNULL_END
