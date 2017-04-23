//
//  UIScrollView+LyHeardRefresh.m
//  LyRefreshDemo
//
//  Created by 张杰 on 2017/4/23.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "UIScrollView+LyHeardRefresh.h"
#import <objc/message.h>

static const char LyRefreshHeaderKey = '\0';
@implementation UIScrollView (LyHeardRefresh)

- (void)setLy_heard:(LyRefreshView *)ly_heard
{
    if (ly_heard != self.ly_heard) {
        //移除旧的，添加新的
        [self.ly_heard removeFromSuperview];
        [self insertSubview:ly_heard atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"ly_header"]; // KVO
        objc_setAssociatedObject(self, &LyRefreshHeaderKey,
                                 ly_heard, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"ly_header"]; // KVO
    }
}

- (LyRefreshView *)ly_heard
{
    //这里用_cmd不行
    return objc_getAssociatedObject(self, &LyRefreshHeaderKey);
}

@end
