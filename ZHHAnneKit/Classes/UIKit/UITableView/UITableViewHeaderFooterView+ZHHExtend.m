//
//  UITableViewHeaderFooterView+ZHHExtend.m
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/11.
//

#import "UITableViewHeaderFooterView+ZHHExtend.h"
#import <objc/runtime.h>

@implementation UITableViewHeaderFooterView (ZHHExtend)

- (void)setZhh_tableView:(UITableView *)zhh_tableView{
    SEL selector = @selector(zhh_tableView);
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    objc_setAssociatedObject(self, selector, zhh_tableView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

- (UITableView *)zhh_tableView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setZhh_section:(NSUInteger)zhh_section{
    SEL selector = @selector(zhh_section);
    [self willChangeValueForKey:NSStringFromSelector(selector)];
    objc_setAssociatedObject(self, selector, @(zhh_section), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:NSStringFromSelector(selector)];
}

- (NSUInteger)zhh_section{
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}
@end
