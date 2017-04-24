//
//  LyViewController.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyViewController.h"
#import "UIScrollView+LyRefresh.h"

@interface LyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *arrayData;

@end

@implementation LyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
    
//    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
//    content.backgroundColor = [UIColor greenColor];
//    self.tableView.tableFooterView = content;
    
    
    __weak typeof(self) weakSelf = self;
    LyHeardRefresh *refreshView = [LyHeardRefresh heardRefreshWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.ly_heard endRefreshWithTitle:@"刷新很20条新数据"];
//            [weakSelf.tableView.ly_heard endRefresh];
        });
    }];
    self.tableView.ly_heard = refreshView;
//    refreshView.autoRefresh = YES;
    
    LyFootRefresh *footer = [LyFootRefresh footWithBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf.arrayData addObjectsFromArray:@[@"1",@"1",@"1"]];
            
            [weakSelf.tableView reloadData];
            if (weakSelf.arrayData.count > 15)
            {
                [weakSelf.tableView.ly_foot endRefresh];
            }
            else
            {
                [weakSelf.tableView.ly_foot endRefresh];
            }
//            [weakSelf.tableView.ly_foot endRefresh];
        });
    }];
    
    self.tableView.ly_foot = footer;
}

- (void)dealloc
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"LyViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell    %ld",indexPath.row];
    
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
//        _tableView.frame = CGRectMake(0, 64, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        _tableView.frame = self.view.bounds;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)arrayData
{
    if (!_arrayData) {
        _arrayData = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 10; i++) {
            [_arrayData addObject:@"1"];
        }
    }
    return _arrayData;
}

@end
