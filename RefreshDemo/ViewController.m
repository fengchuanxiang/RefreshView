//
//  ViewController.m
//  RefreshDemo
//
//  Created by fcx on 15/8/25.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "ViewController.h"
#import "RefreshViewController.h"

static NSString *const CellReuseID = @"CellReuseID";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上下拉刷新";

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 60;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseID];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseID forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"主动上拉加载";
    }else {
        cell.textLabel.text = @"自动上拉加载";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    RefreshViewController *refreshVC = [[RefreshViewController alloc] init];
    if (indexPath.row == 1) {
        refreshVC.autoLoadMore = YES;
    }
    [self.navigationController pushViewController:refreshVC animated:YES];
}

@end
