//
//  LyHeardRefresh.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyHeardRefresh.h"

@interface LyHeardRefresh ()

@property(nonatomic,strong)UIImageView   *logo;
@property(nonatomic,strong)UIImageView   *imageView;
@property(nonatomic,assign)CGFloat       currentProgress;//当前进度

@end

@implementation LyHeardRefresh

+ (instancetype)heardRefreshWithBlock:(beginOperation)operation
{
    LyHeardRefresh *heard = [[LyHeardRefresh alloc] init];
    heard.beginOperation = operation;
    return heard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.currentProgress = 0.0;
        self.refreshState = LyRefreshStateWill;
        [self addSubview:self.imageView];
        [self.imageView addSubview:self.logo];
    }
    return self;
}

- (void)setAutoRefresh:(BOOL)autoRefresh
{
    _autoRefresh = autoRefresh;
    
    if (autoRefresh)
    {
        self.currentProgress = 1.0;
        self.label.hidden = YES;
        self.refreshState = LyRefreshStateIng;
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    UIView *superView = self.superview;
    if ([superView isKindOfClass:[UIScrollView class]])
    {
        self.scrollView = (UIScrollView *)superView;
    }
    
    self.frame = CGRectMake(0, -contentH, self.scrollView.frame.size.width, contentH);
    self.scrollViewEdgeInsets = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40);
    
    self.imageView.bounds = CGRectMake(0, 0, 50, 50);
    self.imageView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.logo.frame = self.imageView.bounds;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:LyRefreshViewObservingkeyPath] || self.refreshState == LyRefreshStateIng) return;
    
    if (self.currentProgress >= 1.0 && self.scrollView.decelerating)//正在刷新
    {
        NSLog(@"正在刷新");
//        [self beginRefresh];
        self.refreshState = LyRefreshStateIng;
        return;
    }
    NSLog(@"将开始");
    //0.更新状态
    if (self.refreshState != LyRefreshStateWill) {
        self.refreshState = LyRefreshStateWill;
    }
    self.label.hidden = YES;
    self.logo.hidden = YES;
    
    //1.求出可见度
    CGFloat h = MAX(0, -self.scrollView.contentOffset.y - self.scrollView.contentInset.top);
    
    //2.进度
    self.currentProgress = MIN(1, h / contentH);
    
    [self updateProgress];
}

- (void)updateProgress
{
    self.imageView.transform = CGAffineTransformMakeScale(self.currentProgress, self.currentProgress);
}

- (void)setRefreshState:(LyRefreshState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == LyRefreshStateIng)
    {
        [UIView animateWithDuration:0.2 animations:^{
            UIEdgeInsets edge = self.scrollView.contentInset;
            edge.top += self.frame.size.height;
            self.scrollView.contentInset = edge;
        }];
        
        NSLog(@"%f",self.scrollView.contentInset.top);
        
        [self beginRefresh];
    }
}

- (void)beginRefresh
{
    [self updateProgress];
    self.logo.hidden = NO;
    self.imageView.layer.borderWidth = 0;
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.logo.transform = CGAffineTransformRotate(self.logo.transform, -M_PI);
    } completion:nil];
}

- (void)endRefresh
{
    [self end];
    
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets edge = self.scrollView.contentInset;
        edge.top -= self.frame.size.height;
        self.scrollView.contentInset = edge;
    } completion:^(BOOL finished) {
        self.refreshState = LyRefreshStateEnd;
        self.imageView.layer.borderWidth = 3;
    }];
}

- (void)end
{
    self.logo.transform = CGAffineTransformIdentity;
    self.imageView.transform = CGAffineTransformIdentity;
    [self.logo.layer removeAllAnimations];
}

//结束刷新
- (void)endRefreshWithTitle:(NSString *)title
{
    [self end];
    self.logo.hidden = YES;
    self.imageView.hidden = YES;
    
    [self showMessage:title];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.2 animations:^{
            UIEdgeInsets edge = self.scrollView.contentInset;
            edge.top -= self.label.frame.size.height;
            self.scrollView.contentInset = edge;
        } completion:^(BOOL finished) {
            self.refreshState = LyRefreshStateEnd;
            self.imageView.hidden = NO;
            self.label.hidden = YES;
            self.imageView.layer.borderWidth = 3;
        }];
        
    });
}

- (void)showMessage:(NSString *)title
{
    self.label.hidden = NO;
    UIEdgeInsets edge = self.scrollView.contentInset;
    edge.top -= (self.frame.size.height - self.label.frame.size.height);
    self.scrollView.contentInset = edge;
    self.label.text = title;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.borderColor = [UIColor orangeColor].CGColor;
        _imageView.layer.borderWidth = 3;
        _imageView.layer.cornerRadius = 25;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)logo
{
    if (!_logo) {
        _logo = [[UIImageView alloc] init];
        _logo.image = [UIImage imageNamed:@"apply_icon_sms"];
        _logo.hidden = YES;
    }
    return _logo;
}

@end
