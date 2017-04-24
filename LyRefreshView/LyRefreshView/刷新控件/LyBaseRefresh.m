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
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self.superview removeObserver:self forKeyPath:LyRefreshViewObservingkeyPath];
        [self.superview removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.frame = CGRectMake(0, 0, self.superview.frame.size.width, contentH);
    
    UIView *superView = self.superview;
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        self.scrollView = (UIScrollView *)superView;
        
        self.originEdgeInsets = _scrollView.contentInset;
        
        [_scrollView addObserver:self forKeyPath:LyRefreshViewObservingkeyPath options:NSKeyValueObservingOptionNew context:nil];
        
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
}

- (void)endRefresh
{
    
}

- (void)endRefreshWithTitle:(NSString *)title
{
    
}

- (void)setRefreshState:(LyRefreshState)refreshState
{
    _refreshState = refreshState;
    
    switch (refreshState) {
        case LyRefreshStateWill:
        {
            
        }
            break;
        case LyRefreshStateIng:
        {
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

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [_activityIndicatorView startAnimating];
    }
    return _activityIndicatorView;
}

@end
