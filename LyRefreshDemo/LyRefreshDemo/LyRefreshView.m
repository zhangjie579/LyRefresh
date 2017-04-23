//
//  LyRefreshView.m
//  LyRefreshDemo
//
//  Created by 张杰 on 2017/4/22.
//  Copyright © 2017年 张杰. All rights reserved.
//

#define kSceneHeight 160.0

#import "LyRefreshView.h"

@interface LyRefreshView ()

@property(nonatomic,strong)UIImageView *groundImageView;
@property(nonatomic,strong)UIImageView *buildingsImageView;
@property(nonatomic,strong)UIImageView *sunImageView;
@property(nonatomic,strong)UIImageView *catImageView;
@property(nonatomic,strong)UIImageView *capeBackImageView;
@property(nonatomic,strong)UIImageView *capeFrontImageView;

@property(nonatomic,strong)UIImageView *cloudImageView1;
@property(nonatomic,strong)UIImageView *cloudImageView2;
@property(nonatomic,strong)UIImageView *cloudImageView3;
@property(nonatomic,strong)NSMutableArray<LyRefreshItem *> *array;

@property(nonatomic,assign)CGFloat         progress;//进度
@property(nonatomic,assign)BOOL            isRefreshing;//是否正在刷新
@property(nonatomic,weak  )UIScrollView    *scrollView;//注意:这里要用weak
@property(nonatomic,copy  )Ly_heardRefresh ly_heardRefresh;
@end

@implementation LyRefreshView

+ (instancetype)heardRefreshWithBlock:(Ly_heardRefresh)heardRefresh
{
    LyRefreshView *heard = [[LyRefreshView alloc] init];
    heard.ly_heardRefresh = heardRefresh;
    return heard;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.progress = 0.0;
        self.isRefreshing = NO;
        [self updateBackgroundColor];
        [self setupRefreshItems];
    }
    return self;
}

- (void)dealloc
{
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview) {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
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
}

- (void)setAutoRefresh:(BOOL)autoRefresh
{
    _autoRefresh = autoRefresh;
    
    if (autoRefresh) {
        self.progress = 1.0;
        [self beginRefreshing];
    }
}

#pragma mark - 更新视图操作
- (void)updateBackgroundColor
{
    self.backgroundColor = [UIColor colorWithWhite:0.2 + 0.7 * self.progress alpha:1.0];
}

- (void)updateRefreshItemPositions
{
    for (LyRefreshItem *item in self.array) {
        [item updateViewPositionForPercent:self.progress];
    }
}

- (void)setupRefreshItems
{
    [self addSubview:self.buildingsImageView];
    [self addSubview:self.sunImageView];
    [self addSubview:self.groundImageView];
    [self addSubview:self.capeBackImageView];
    [self addSubview:self.catImageView];
    [self addSubview:self.capeFrontImageView];
    [self addSubview:self.cloudImageView1];
    [self addSubview:self.cloudImageView2];
    [self addSubview:self.cloudImageView3];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    [self setupImageView:scrollView];
}

#pragma mark - 设置子视图的位置
- (void)setupImageView:(UIScrollView *)scrollView
{
    self.frame = CGRectMake(0, -200, scrollView.bounds.size.width, 200);
//    [scrollView insertSubview:self atIndex:0];
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat centerX = w / 2;
    
    LyRefreshItem *itme1 = [[LyRefreshItem alloc] initWithView:self.buildingsImageView centerEnd:CGPointMake(centerX, h - self.groundImageView.frame.size.height - self.buildingsImageView.frame.size.height / 2) parallaxRatio:1.5 sceneHeight:kSceneHeight];
    
    //    LyRefreshItem *itme2 = [[LyRefreshItem alloc] initWithView:self.sunImageView centerEnd:CGPointMake(w * 0.1, h - self.groundImageView.frame.size.height - self.sunImageView.frame.size.height) parallaxRatio:3 sceneHeight:kSceneHeight];
    
    LyRefreshItem *itme2 = [[LyRefreshItem alloc] initWithView:self.sunImageView centerEnd:CGPointMake(w * 0.1, h - self.groundImageView.frame.size.height - self.buildingsImageView.frame.size.height - self.sunImageView.frame.size.height / 2) parallaxRatio:3 sceneHeight:kSceneHeight];
    
    LyRefreshItem *itme3 = [[LyRefreshItem alloc] initWithView:self.groundImageView centerEnd:CGPointMake(centerX, h - self.groundImageView.frame.size.height / 2) parallaxRatio:0.5 sceneHeight:kSceneHeight];
    
    LyRefreshItem *itme4 = [[LyRefreshItem alloc] initWithView:self.capeBackImageView centerEnd:CGPointMake(centerX, h - self.groundImageView.frame.size.height / 2 - self.capeBackImageView.frame.size.height / 2) parallaxRatio:-1 sceneHeight:kSceneHeight];
    
    LyRefreshItem *itme5 = [[LyRefreshItem alloc] initWithView:self.catImageView centerEnd:CGPointMake(centerX, h - self.groundImageView.frame.size.height / 2 - self.catImageView.frame.size.height / 2) parallaxRatio:1.0 sceneHeight:kSceneHeight];
    
    LyRefreshItem *itme6 = [[LyRefreshItem alloc] initWithView:self.capeFrontImageView centerEnd:CGPointMake(centerX, h - self.groundImageView.frame.size.height / 2 - self.capeFrontImageView.frame.size.height / 2) parallaxRatio:-1 sceneHeight:kSceneHeight];
    
    //太阳最大的X值
    CGFloat sunX = CGRectGetMaxX(self.sunImageView.frame);
    
    //平分☁️直接的间隙，4等分
    CGFloat lineW = (w - sunX - self.cloudImageView1.frame.size.width - self.cloudImageView2.frame.size.width - self.cloudImageView3.frame.size.width) / 4;
    
    //☁️的中点Y
    CGFloat centerY = h - self.groundImageView.frame.size.height - self.buildingsImageView.frame.size.height - self.cloudImageView1.frame.size.height / 2 - 15;
    
    CGFloat centerXCloud1 = sunX + self.cloudImageView1.frame.size.width / 2 + lineW;
    
    LyRefreshItem *itme7 = [[LyRefreshItem alloc] initWithView:self.cloudImageView1 centerEnd:CGPointMake(centerXCloud1, centerY) parallaxRatio:-2 sceneHeight:kSceneHeight];
    
    CGFloat centerXCloud2 = CGRectGetMaxX(self.cloudImageView1.frame) + self.cloudImageView2.frame.size.width / 2 + lineW;
    
    LyRefreshItem *itme8 = [[LyRefreshItem alloc] initWithView:self.cloudImageView2 centerEnd:CGPointMake(centerXCloud2, centerY) parallaxRatio:-2 sceneHeight:kSceneHeight];
    
    CGFloat centerXCloud3 = CGRectGetMaxX(self.cloudImageView2.frame) + self.cloudImageView3.frame.size.width / 2 + lineW;
    
    LyRefreshItem *itme9 = [[LyRefreshItem alloc] initWithView:self.cloudImageView3 centerEnd:CGPointMake(centerXCloud3, centerY) parallaxRatio:-2 sceneHeight:kSceneHeight];
    
    [self.array addObjectsFromArray:@[itme1,itme2,itme3,itme4,itme5,itme6,itme7,itme8,itme9]];
}

#pragma mark - 监听滑动
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.isRefreshing) {
        return;
    }
    
    if (object == self.scrollView && [keyPath isEqualToString:@"contentOffset"])
    {
        if (self.scrollView.decelerating && self.progress >= 1.0)//停止了拖拽，但还在滑动
        {
            NSLog(@"停止了拖拽，但还在滑动");
            //开始刷新
            [self beginRefreshing];
            return;
        }
        NSLog(@"将要刷新");
        //1.先拿到刷新视图可见区域的高度
        CGFloat h = MAX(0, -self.scrollView.contentOffset.y - self.scrollView.contentInset.top);
        //2.求进度
        self.progress = MIN(1, h / kSceneHeight);
        //3.更新视图
        [self updateBackgroundColor];
        [self updateRefreshItemPositions];
    }
}

- (void)beginRefreshing
{
    self.isRefreshing = YES;
    [self updateBackgroundColor];
    [self updateRefreshItemPositions];
    
    if (self.ly_heardRefresh) {
        self.ly_heardRefresh();
    }
    if ([self.delegate respondsToSelector:@selector(lyRefreshViewWithHeardRefreshing:)]) {
        [self.delegate lyRefreshViewWithHeardRefreshing:self];
    }
    
    //停滞,显示刷新视图
    [UIView animateWithDuration:0.4 animations:^{
        UIEdgeInsets edge = self.scrollView.contentInset;
        edge.top += kSceneHeight;
        self.scrollView.contentInset = edge;
    } completion:^(BOOL finished) {
        
    }];
    
    //☁️的动画
    CGFloat h = self.frame.size.height - self.cloudImageView1.frame.origin.y;
    [UIView animateKeyframesWithDuration:5.0 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        self.cloudImageView1.transform = CGAffineTransformTranslate(self.cloudImageView1.transform, self.frame.size.width, -h);
        self.cloudImageView2.transform = CGAffineTransformTranslate(self.cloudImageView2.transform, self.frame.size.width, -h - 20);
        self.cloudImageView3.transform = CGAffineTransformTranslate(self.cloudImageView3.transform, self.frame.size.width, -h - 40);
    } completion:nil];
    
    //🌞的动画
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionRepeat animations:^{
        self.sunImageView.transform = CGAffineTransformRotate(self.sunImageView.transform, M_PI / 8);
    } completion:nil];
    
    //猫和斗篷动画
    self.capeFrontImageView.transform = CGAffineTransformMakeRotation(- M_PI / 32);
    self.catImageView.transform = CGAffineTransformMakeTranslation(1.0, 0);
    
    //重复动画，并且开始位置和结束位置重复调用
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionAutoreverse animations:^{
        self.capeFrontImageView.transform = CGAffineTransformMakeRotation(M_PI / 32);
        self.catImageView.transform = CGAffineTransformMakeTranslation(-1.0, 0);
    } completion:nil];
    
    //地面和建筑动画
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGPoint groundCenter = self.groundImageView.center;
        groundCenter.y += kSceneHeight;
        self.groundImageView.center = groundCenter;
        
        CGPoint buildCenter = self.buildingsImageView.center;
        buildCenter.y += kSceneHeight;
        self.groundImageView.center = groundCenter;
        self.buildingsImageView.center = buildCenter;
        
    } completion:nil];
}

- (void)endRefreshing
{
    [UIView animateWithDuration:0.4 animations:^{
        UIEdgeInsets edge = self.scrollView.contentInset;
        edge.top -= kSceneHeight;
        self.scrollView.contentInset = edge;
    } completion:^(BOOL finished) {
        self.isRefreshing = NO;
    }];
    
    self.sunImageView.transform = CGAffineTransformIdentity;
    self.capeFrontImageView.transform = CGAffineTransformIdentity;
    self.catImageView.transform = CGAffineTransformIdentity;
    self.cloudImageView1.transform = CGAffineTransformIdentity;
    self.cloudImageView2.transform = CGAffineTransformIdentity;
    self.cloudImageView3.transform = CGAffineTransformIdentity;
    
    [self.capeFrontImageView.layer removeAllAnimations];
    [self.sunImageView.layer removeAllAnimations];
    [self.groundImageView.layer removeAllAnimations];
    [self.catImageView.layer removeAllAnimations];
    [self.cloudImageView1.layer removeAllAnimations];
    [self.cloudImageView2.layer removeAllAnimations];
    [self.cloudImageView3.layer removeAllAnimations];
}
#pragma mark - get
- (UIImageView *)groundImageView
{
    if (!_groundImageView) {
        _groundImageView = [[UIImageView alloc] init];
        _groundImageView.image = [UIImage imageNamed:@"ground"];
        [_groundImageView sizeToFit];
    }
    return _groundImageView;
}

- (UIImageView *)buildingsImageView
{
    if (!_buildingsImageView) {
        _buildingsImageView = [[UIImageView alloc] init];
        _buildingsImageView.image = [UIImage imageNamed:@"buildings"];
        [_buildingsImageView sizeToFit];
    }
    return _buildingsImageView;
}

- (UIImageView *)sunImageView
{
    if (!_sunImageView) {
        _sunImageView = [[UIImageView alloc] init];
        _sunImageView.image = [UIImage imageNamed:@"sun"];
        [_sunImageView sizeToFit];
    }
    return _sunImageView;
}

- (UIImageView *)catImageView
{
    if (!_catImageView) {
        _catImageView = [[UIImageView alloc] init];
        _catImageView.image = [UIImage imageNamed:@"cat"];
        [_catImageView sizeToFit];
    }
    return _catImageView;
}

- (UIImageView *)capeBackImageView
{
    if (!_capeBackImageView) {
        _capeBackImageView = [[UIImageView alloc] init];
        _capeBackImageView.image = [UIImage imageNamed:@"cape_back"];
        [_capeBackImageView sizeToFit];
    }
    return _capeBackImageView;
}

- (UIImageView *)capeFrontImageView
{
    if (!_capeFrontImageView) {
        _capeFrontImageView = [[UIImageView alloc] init];
        _capeFrontImageView.image = [UIImage imageNamed:@"cape_front"];
        [_capeFrontImageView sizeToFit];
    }
    return _capeFrontImageView;
}

- (UIImageView *)cloudImageView1
{
    if (!_cloudImageView1) {
        _cloudImageView1 = [[UIImageView alloc] init];
        _cloudImageView1.image = [UIImage imageNamed:@"cloud_3"];
        [_cloudImageView1 sizeToFit];
    }
    return _cloudImageView1;
}

- (UIImageView *)cloudImageView2
{
    if (!_cloudImageView2) {
        _cloudImageView2 = [[UIImageView alloc] init];
        _cloudImageView2.image = [UIImage imageNamed:@"cloud_1"];
        [_cloudImageView2 sizeToFit];
    }
    return _cloudImageView2;
}

- (UIImageView *)cloudImageView3
{
    if (!_cloudImageView3) {
        _cloudImageView3 = [[UIImageView alloc] init];
        _cloudImageView3.image = [UIImage imageNamed:@"cloud_2"];
        [_cloudImageView3 sizeToFit];
    }
    return _cloudImageView3;
}

- (NSMutableArray<LyRefreshItem *> *)array
{
    if (!_array) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}

@end


@interface LyRefreshItem ()

@property(nonatomic,assign)CGPoint centerStart;
@property(nonatomic,assign)CGPoint centerEnd;
@property(nonatomic,weak  )UIView  *view;

@end

@implementation LyRefreshItem

/**

 @param item 视图
 @param centerEnd 结束的位置
 @param parallaxRatio 速率
 @param sceneHeight 高度
 @return LyRefreshItem
 */
- (instancetype)initWithView:(UIView *)item centerEnd:(CGPoint)centerEnd parallaxRatio:(CGFloat)parallaxRatio sceneHeight:(CGFloat)sceneHeight
{
    if (self = [super init]) {
        self.view = item;
        self.centerEnd = centerEnd;
        
        CGFloat y = centerEnd.y + parallaxRatio * sceneHeight;
        self.centerStart = CGPointMake(centerEnd.x, y);
        self.view.center = self.centerStart;
    }
    return self;
}

- (void)updateViewPositionForPercent:(CGFloat)percent
{
    CGFloat x = self.centerStart.x + (self.centerEnd.x - self.centerStart.x) * percent;
    CGFloat y = self.centerStart.y + (self.centerEnd.y - self.centerStart.y) * percent;
    self.view.center = CGPointMake(x, y);
}

@end

