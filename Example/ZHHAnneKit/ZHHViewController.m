//
//  ZHHViewController.m
//  ZHHAnneKit
//
//  Created by ningxiaomo0516 on 09/11/2022.
//  Copyright (c) 2022 ningxiaomo0516. All rights reserved.
//

#import "ZHHViewController.h"
#import <ZHHAnneKit/ZHHAnneKit.h>
#import "NonHoveringHeaderView.h"
#import "HoveringHeaderView.h"

@interface ZHHViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISwitch *switchView;
@end

@implementation ZHHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self.view zhh_addTapActionWithBlock:^(UIGestureRecognizer * _Nonnull gestureRecoginzer) {
//        NSLog(@"点击事件");
//    }];
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = UIColor.orangeColor;
    label.text = @"点击事件";
    label.frame = CGRectMake(0, 0, 200, 50);
    label.center = self.view.center;
//    label.userInteractionEnabled = YES;
    [self.view addSubview:label];
    [label zhh_addTapActionWithBlock:^(UIGestureRecognizer * _Nonnull gestureRecoginzer) {
        NSLog(@"label点击事件");
    }];
    [self.tableView registerClass:NonHoveringHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(NonHoveringHeaderView.class)];
    [self.tableView registerClass:HoveringHeaderView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(HoveringHeaderView.class)];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.switchView];
    [self.view bringSubviewToFront:self.switchView];
    self.tableView.frame = self.view.frame;
    self.switchView.center = self.view.center;
}

#pragma mark -- UISwitch

- (IBAction)handleSwitchEvent:(UISwitch *)sender {
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    cell.textLabel.text = (indexPath.row ? @"1234" : @"qwer");
    return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    Class headerClass = self.switchView.isOn ? NonHoveringHeaderView.class : HoveringHeaderView.class;
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(headerClass)];
    header.zhh_tableView = tableView;
    header.zhh_section = section;
    header.textLabel.text = @"测试";
    return header;
}

#pragma mark -- getter method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = UIView.new;
    }
    return _tableView;
}

- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        //位置的x,y可以改，但是按钮宽、高不可以改，就算设置了也没效果
        _switchView.frame = CGRectMake(100, 200, 80, 40);
        [_switchView addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
