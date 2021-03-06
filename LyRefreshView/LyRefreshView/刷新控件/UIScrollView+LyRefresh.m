//
//  UIScrollView+LyRefresh.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/4/23.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "UIScrollView+LyRefresh.h"
#import <objc/message.h>

@implementation UIScrollView (LyRefresh)

static const char LyRefreshHeaderKey = '\0';
- (void)setLy_heard:(LyHeardRefresh *)ly_heard
{
    if (ly_heard != self.ly_heard) {
        
        //移除旧的添加新的
        [self.ly_heard removeFromSuperview];
        [self insertSubview:ly_heard atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"ly_header"]; // KVO
        objc_setAssociatedObject(self, &LyRefreshHeaderKey,
                                 ly_heard, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"ly_header"]; // KVO
    }
}

- (LyHeardRefresh *)ly_heard
{
    return objc_getAssociatedObject(self, &LyRefreshHeaderKey);
}

#pragma mark - 下拉刷新
static const char LyRefreshFooterKey = '\0';
- (void)setLy_foot:(LyFootRefresh *)ly_foot
{
    if (ly_foot != self.ly_foot)
    {
        //移除旧的添加新的
        [self.ly_foot removeFromSuperview];
        [self insertSubview:ly_foot atIndex:0];
//        [self addSubview:ly_foot];
        
        // 存储新的
        [self willChangeValueForKey:@"ly_foot"]; // KVO
        objc_setAssociatedObject(self, &LyRefreshFooterKey,
                                 ly_foot, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"ly_foot"]; // KVO
    }
}

- (LyFootRefresh *)ly_foot
{
    return objc_getAssociatedObject(self, &LyRefreshFooterKey);
}

@end
