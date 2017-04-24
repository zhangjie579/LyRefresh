//
//  LyHeardRefresh.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyHeardRefresh.h"

@interface LyHeardRefresh ()

@property(nonatomic,strong)UILabel       *label;
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
        self.refreshState = LyRefreshStateEnd;
        [self addSubview:self.label];
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
    
    self.frame = CGRectMake(0, -contentH, self.scrollView.frame.size.width, contentH);
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
    
    if (self.scrollView.decelerating)//停止了拖拽
    {
        if (self.currentProgress >= 1.0)
        {
            self.refreshState = LyRefreshStateIng;
        }
        else
        {
            self.refreshState = LyRefreshStateEnd;
        }
        return;
    }
//    NSLog(@"将开始");
    //0.更新状态
    if (self.refreshState != LyRefreshStateWill) {
        self.refreshState = LyRefreshStateWill;
    }
    
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
    
    switch (refreshState) {
        case LyRefreshStateWill://将开始
        {
            self.label.hidden = YES;
            self.logo.hidden = YES;
        }
            break;
        case LyRefreshStateIng://正在刷新
        {
            [UIView animateWithDuration:0.2 animations:^{
                UIEdgeInsets edge = self.scrollView.contentInset;
                edge.top += self.frame.size.height;
                self.scrollView.contentInset = edge;
            }];
            
            [self beginRefresh];
        }
            break;
        case LyRefreshStateEnd://刷新结束
        {
            self.imageView.hidden = NO;
            self.imageView.layer.borderWidth = 3;
            self.label.hidden = YES;
        }
            break;
            
        default:
            break;
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
    if (![title isEqualToString:@""] && title != nil)
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
            }];
        });
    }
    else
    {
        [self endRefresh];
    }
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

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
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
