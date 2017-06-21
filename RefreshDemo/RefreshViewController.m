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

static NSString *const FCXRefreshCellReuseID = @"FCXRefreshCellReuseID";

@interface RefreshViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger _rows;
    UITableView *_tableView;
    FCXRefreshHeaderView *_headerView;
    FCXRefreshFooterView *_footerView;
}


@end

@implementation RefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.title = @"上下拉刷新";
    
    _rows = 12;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FCXRefreshCellReuseID];
    [self.view addSubview:_tableView];
    
    [self addRefreshView];
}

- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    
    //下拉刷新
    _headerView = [_tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf refreshAction];
    }];
    
    //上拉加载更多
    _footerView = [_tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf loadMoreAction];
    }];
    
    //自动刷新
    _footerView.autoLoadMore = self.autoLoadMore;
}

- (void)refreshAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows = 12;
        [_tableView reloadData];
        [_headerView endRefresh];
    });
}

- (void)loadMoreAction {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _rows += 12;
        [_tableView reloadData];
        if (_rows > 24) {
            [_footerView showNoMoreData];
        }else {
            [_footerView endRefresh];
        }
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FCXRefreshCellReuseID forIndexPath:indexPath];
       cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}

- (void)dealloc {
    [_headerView removeScrollViewObservers];
    [_footerView removeScrollViewObservers];
}

@end
