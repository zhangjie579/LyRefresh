//
//  LyBaseRefresh.h
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//
#define contentH 70.0

typedef enum {
    LyRefreshStateWill,
    LyRefreshStateIng,
    LyRefreshStateEnd,
}LyRefreshState;

#import <UIKit/UIKit.h>

typedef void(^beginOperation)();

static NSString *const LyRefreshViewObservingkeyPath = @"contentOffset";

@interface LyBaseRefresh : UIView

@property(nonatomic,strong)UILabel          *label;
@property(nonatomic,  weak)UIScrollView     *scrollView;
@property(nonatomic,  copy)beginOperation   beginOperation;

@property (nonatomic, assign)LyRefreshState refreshState;//刷新状态
// 子类自定义位置使用
@property (nonatomic, assign) UIEdgeInsets scrollViewEdgeInsets;

+ (instancetype)refreshView;

- (void)endChangeEdgeInset;

- (void)endRefresh;
@end
