//
//  LyHeardRefresh.h
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyBaseRefresh.h"

@interface LyHeardRefresh : LyBaseRefresh

//注意:这个参数要在设置了self.tableView.ly_heard = self;之后,只有设置了这个，self才添加到了tableview中
@property(nonatomic,assign,getter=isAutoRefresh)BOOL autoRefresh;//第一次是否默认自动刷新

+ (instancetype)heardRefreshWithBlock:(beginOperation)operation;

- (void)endRefreshWithTitle:(NSString *)title;

@end
