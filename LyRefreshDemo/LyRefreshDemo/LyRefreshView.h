//
//  LyRefreshView.h
//  LyRefreshDemo
//
//  Created by 张杰 on 2017/4/22.
//  Copyright © 2017年 张杰. All rights reserved.
//

typedef void(^Ly_heardRefresh)();

#import <UIKit/UIKit.h>
@class LyRefreshView;

@protocol LyRefreshViewDelegate <NSObject>

@optional
- (void)lyRefreshViewWithHeardRefreshing:(LyRefreshView *)heardView;
@end

@interface LyRefreshView : UIView

@property(nonatomic,weak)id<LyRefreshViewDelegate> delegate;

+ (instancetype)heardRefreshWithBlock:(Ly_heardRefresh)heardRefresh;

- (void)endRefreshing;

//注意:这个参数要在设置了self.tableView.ly_heard = self;之后,只有设置了这个，self才添加到了tableview中
@property(nonatomic,assign,getter=isAutoRefresh)BOOL autoRefresh;//第一次是否默认自动刷新

@end

#pragma mark - LyRefreshItem用于计算imageview的位置
@interface LyRefreshItem : NSObject

/**
 
 @param item 视图
 @param centerEnd 结束的位置
 @param parallaxRatio 速率
 @param sceneHeight 高度
 @return LyRefreshItem
 */
- (instancetype)initWithView:(UIView *)item centerEnd:(CGPoint)centerEnd parallaxRatio:(CGFloat)parallaxRatio sceneHeight:(CGFloat)sceneHeight;

- (void)updateViewPositionForPercent:(CGFloat)percent;
@end
