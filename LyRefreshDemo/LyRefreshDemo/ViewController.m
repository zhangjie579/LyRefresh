//
//  ViewController.m
//  LyRefreshDemo
//
//  Created by 张杰 on 2017/4/22.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "ViewController.h"
#import "LyRefreshView.h"
#import "UIScrollView+LyHeardRefresh.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,LyRefreshViewDelegate>

@property(nonatomic,strong)UITableView    *tableView;
@property(nonatomic,strong)LyRefreshView  *refreshView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    LyRefreshView *heard = [LyRefreshView heardRefreshWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView.ly_heard endRefreshing];
        });
    }];
    self.tableView.ly_heard = heard;
    heard.autoRefresh = YES;
    
}

- (void)lyRefreshViewWithHeardRefreshing:(LyRefreshView *)heardView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [heardView endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell_%ld",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.allowsSelectionDuringEditing = YES;
//        _tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    }
    return _tableView;
}

- (LyRefreshView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [[LyRefreshView alloc] init];
        _refreshView.delegate = self;
    }
    return _refreshView;
}

@end
