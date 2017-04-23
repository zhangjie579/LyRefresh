# LyRefresh
刷新控件
```
__weak typeof(self) weakSelf = self;
    LyRefreshView *heard = [LyRefreshView heardRefreshWithBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf.tableView.ly_heard endRefreshing];
        });
    }];
    self.tableView.ly_heard = heard;
    heard.autoRefresh = YES;
    
