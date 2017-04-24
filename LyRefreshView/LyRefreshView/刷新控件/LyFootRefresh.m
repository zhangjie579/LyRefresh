//
//  LyFootRefresh.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/4/24.
//  Copyright © 2017年 张杰. All rights reserved.
//
#define kFootViewH 70
#define kLabelH 40

#import "LyFootRefresh.h"

@interface LyFootRefresh ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,assign)CGFloat currentPercent;

@end

@implementation LyFootRefresh

+ (instancetype)footWithBlock:(beginOperation)operation
{
    LyFootRefresh *foot = [[LyFootRefresh alloc] init];
    foot.beginOperation = operation;
    return foot;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.refreshState = LyRefreshStateEnd;
        self.currentPercent = 0.0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
        [self.label addSubview:self.activityIndicatorView];
        self.activityIndicatorView.hidden = NO;
    }
    return self;
}

- (void)changeFrame
{
    CGFloat y = self.scrollView.contentSize.height + self.originEdgeInsets.bottom;
    if (y != self.frame.origin.y)
    {
        self.frame = CGRectMake(0, y, self.scrollView.frame.size.width, kFootViewH);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(10, 15, self.frame.size.width - 20, kLabelH);
    
    [self updateActivityFrameWithTitle:self.label.text];
}

//更新菊花的位置
- (void)updateActivityFrameWithTitle:(NSString *)title
{
    if (self.label.frame.size.width <= 0) {
        return;
    }
    
    if ([self.label.text isEqualToString:title] && self.activityIndicatorView.frame.origin.x > 0) {
        return;
    }
    
    self.label.text = title;
    
    CGFloat w = [self sizeWithText:self.label.text font:self.label.font maxSize:CGSizeMake(self.frame.size.width - 20, 20)].width;
    CGFloat x = (self.label.frame.size.width - w) / 2;
    
    self.activityIndicatorView.frame = CGRectMake(x - 15 - 15, (kLabelH - 15) / 2, 15, 15);
}

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    int width = ceilf(size.width);
    size.width = (float)width;
    return size;
}

#pragma mark - 监听kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.refreshState == LyRefreshStateIng) return;
    
    if ([keyPath isEqualToString:LyRefreshViewObservingkeyPath])
    {
        if (self.scrollView.decelerating)//停止了拖拽
        {
            if (self.currentPercent >= 1.0)
            {
                NSLog(@"正在");
                self.refreshState = LyRefreshStateIng;
            }
            else
            {
                NSLog(@"结束");
                self.refreshState = LyRefreshStateEnd;
            }
            return;
        }
        
        NSLog(@"将刷新");
        
        //0.改变刷新状态
        if (self.refreshState != LyRefreshStateWill) {
            self.refreshState = LyRefreshStateWill;
        }
        
        //1.求出最大的可滑动高度
        CGFloat scrolMaxH = self.scrollView.contentSize.height - self.scrollView.frame.size.height;
        CGFloat y = self.scrollView.contentOffset.y - self.scrollView.contentInset.bottom;
        
        //2.求出可见范围
        CGFloat h = MAX(0, y - scrolMaxH);
        
        //3.求进度
        self.currentPercent = MIN(1, h / kFootViewH);
    }
    else if ([keyPath isEqualToString:@"contentSize"])
    {
        [self changeFrame];
    }
}

- (void)endRefresh
{
    [UIView animateWithDuration:0.5 animations:^{
        UIEdgeInsets edge = self.scrollView.contentInset;
        edge.bottom -= self.frame.size.height;
        self.scrollView.contentInset = edge;
    } completion:^(BOOL finished) {
        self.refreshState = LyRefreshStateEnd;
    }];
}

- (void)setRefreshState:(LyRefreshState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == LyRefreshStateIng)//正在刷新
    {
        [self updateActivityFrameWithTitle:@"正在载入"];
        
        [self changeFrame];
        if (!self.activityIndicatorView.isAnimating) {
            [self.activityIndicatorView startAnimating];
        }
        [UIView animateWithDuration:0.2 animations:^{
            UIEdgeInsets edge = self.scrollView.contentInset;
            edge.bottom += self.frame.size.height;
            self.scrollView.contentInset = edge;
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else if (refreshState == LyRefreshStateWill)//将刷新
    {
        [self updateActivityFrameWithTitle:@"上拉刷新"];
        
        if (!self.activityIndicatorView.isAnimating) {
            [self.activityIndicatorView startAnimating];
        }
    }
    else if (refreshState == LyRefreshStateEnd)
    {
        if (self.activityIndicatorView.isAnimating) {
            [self.activityIndicatorView stopAnimating];
        }
        [self changeFrame];
    }
}

#pragma mark - get
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor lightGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.borderWidth = 2;
        _label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _label.layer.cornerRadius = 5;
        _label.clipsToBounds = YES;
    }
    return _label;
}

@end
