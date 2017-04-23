//
//  LyProcessView.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/19.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyProcessView.h"

@interface LyProcessView ()

@property(nonatomic,strong)CAGradientLayer *pradientLayer;//多彩的layer
@property(nonatomic,strong)CAShapeLayer    *backgroundLayer;//路径条

@end

@implementation LyProcessView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.progress = 0.0;
//        [self.layer addSublayer:self.backgroundLayer];
//        [self.baseLayer addSublayer:self.pradientLayer];
        [self.layer addSublayer:self.pradientLayer];
    }
    return self;
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    self.backgroundLayer.lineWidth = radius;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = MAX(0.0, MIN(progress, 1.0));
    
    CGFloat radius = MIN(self.frame.size.width / 2, self.frame.size.height / 2) - self.radius;
    
    CGFloat angle = -M_PI_2 + M_PI * 2 * _progress;
    
    self.backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:radius startAngle:-M_PI_2 endAngle:angle clockwise:YES].CGPath;
    
//    [self performAnimation];
    
    //这一步的作用是让layer的路径为圆
    self.pradientLayer.mask = self.backgroundLayer;
    
}

- (void)performAnimation
{
    // Move the last color in the array to the front
    // shifting all the other colors.
    //取出最后一个颜色来，并把最后1个颜色放到第1个
    NSMutableArray *mutable = [[self.pradientLayer colors] mutableCopy];
    id lastColor = [mutable lastObject];
    [mutable removeLastObject];
    [mutable insertObject:lastColor atIndex:0];
    NSArray *shiftedColors = [NSArray arrayWithArray:mutable];
    
    // Update the colors on the model layer
    [self.pradientLayer setColors:shiftedColors];
    
    // Create an animation to slowly move the gradient left to right.
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.toValue = shiftedColors;
    animation.duration = 0.02;
    [animation setRemovedOnCompletion:YES];
    [animation setFillMode:kCAFillModeForwards];
    [self.pradientLayer addAnimation:animation forKey:@"animateGradient"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //注意这里要用bounds，不能用frame
    self.backgroundLayer.frame = self.bounds;
    self.pradientLayer.frame = self.bounds;
    self.pradientLayer.cornerRadius = self.frame.size.height / 2;
    self.pradientLayer.masksToBounds = YES;
}

- (CAGradientLayer *)pradientLayer
{
    if (!_pradientLayer) {
        _pradientLayer = [CAGradientLayer layer];
        
        NSMutableArray *colors = [NSMutableArray array];
        for (NSInteger hue = 0; hue <= 360; hue += 5) {
            
            UIColor *color = [UIColor colorWithHue:1.0 * hue / 360.0
                                        saturation:1.0
                                        brightness:1.0
                                             alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [_pradientLayer setColors:[NSArray arrayWithArray:colors]];
        //        [_pradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
        //        [_pradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
    }
    return _pradientLayer;
}

- (CAShapeLayer *)backgroundLayer
{
    if (!_backgroundLayer) {
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
        _backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    }
    return _backgroundLayer;
}


@end
