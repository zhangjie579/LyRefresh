//
//  UIScrollView+LyRefresh.h
//  LyRefreshView
//
//  Created by 张杰 on 2017/4/23.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyHeardRefresh.h"
#import "LyFootRefresh.h"

@interface UIScrollView (LyRefresh)

@property(nonatomic,strong)LyHeardRefresh *ly_heard;
@property(nonatomic,strong)LyFootRefresh  *ly_foot;

@end
