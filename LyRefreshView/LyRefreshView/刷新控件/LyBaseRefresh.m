//
//  LyBaseRefresh.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyBaseRefresh.h"

@interface LyBaseRefresh ()

@end

@implementation LyBaseRefresh

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.label];
    }
    return self;
}

+ (instancetype)refreshView
{
    return [[self alloc] init];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self.superview removeObserver:self forKeyPath:LyRefreshViewObservingkeyPath];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, contentH);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [_scrollView addObserver:self forKeyPath:LyRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)beginChangeEdgeInset
{
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.top += self.scrollViewEdgeInsets.top;
    edge.bottom += self.scrollViewEdgeInsets.bottom;
    edge.left += self.scrollViewEdgeInsets.left;
    edge.right += self.scrollViewEdgeInsets.right;
    self.scrollView.contentInset = edge;
}

- (void)endChangeEdgeInset
{
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.top -= self.scrollViewEdgeInsets.top;
    edge.bottom -= self.scrollViewEdgeInsets.bottom;
    edge.left -= self.scrollViewEdgeInsets.left;
    edge.right -= self.scrollViewEdgeInsets.right;
    self.scrollView.contentInset = edge;
}

- (void)endRefresh
{
    [UIView animateWithDuration:0.5 animations:^{
        [self endChangeEdgeInset];
    } completion:^(BOOL finished) {
        self.refreshState = LyRefreshStateEnd;
    }];
}

- (void)setRefreshState:(LyRefreshState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
        case LyRefreshStateWill:
        {
            self.label.text = @"将开始";
        }
            break;
        case LyRefreshStateIng:
        {
            self.label.text = @"正在刷新";
            
//            [UIView animateWithDuration:0.2 animations:^{
//                [self beginChangeEdgeInset];
//            }];
            
            NSLog(@"%f",self.scrollView.contentInset.top);
            
            if (self.beginOperation) {
                self.beginOperation();
            }
            
        }
            break;
        case LyRefreshStateEnd:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:18];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
