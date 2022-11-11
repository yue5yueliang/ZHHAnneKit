//
//  UITableViewHeaderFooterView+ZHHExtend.h
//  ZHHAnneKit
//
//  Created by 桃色三岁 on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewHeaderFooterView (ZHHExtend)
@property (nonatomic, weak)   UITableView *zhh_tableView;
@property (nonatomic, assign) NSUInteger zhh_section;
@end

NS_ASSUME_NONNULL_END
