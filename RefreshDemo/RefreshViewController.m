//
//  RefreshViewController.m
//  RefreshDemo
//
//  Created by fcx on 15/8/25.
//  Copyright (c) 2015年 fcx. All rights reserved.
//

#import "RefreshViewController.h"
#import "FCXRefreshFooterView.h"
#import "FCXRefreshHeaderView.h"
#import "UIScrollView+FCXRefresh.h"

@interface RefreshViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger rows;
    UITableView *mTableView;
    FCXRefreshHeaderView *headerView;
    FCXRefreshFooterView *footerView;
}


@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"上下拉刷新";
    
    rows = 12;
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.rowHeight = 60;
    [self.view addSubview:mTableView];
    
    [self addRefreshView];
}

- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    headerView = [mTableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    footerView = [mTableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    footerView.autoLoadMore = self.autoLoadMore;
}

- (void)refreshAction {
    __weak UITableView *weakTableView = mTableView;
    __weak FCXRefreshHeaderView *weakHeaderView = headerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        rows = 12;
        [weakTableView reloadData];
        [weakHeaderView endRefresh];
    });
}

- (void)loadMoreAction {
    __weak UITableView *weakTableView = mTableView;
    __weak FCXRefreshFooterView *weakFooterView = footerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        rows += 12;
        [weakTableView reloadData];
        [weakFooterView endRefresh];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    return cell;
}

@end
