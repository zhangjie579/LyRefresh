//
//  ViewController.m
//  LyRefreshView
//
//  Created by 张杰 on 2017/3/18.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "ViewController.h"
#import "LyViewController.h"

@interface ViewController ()

- (IBAction)tap:(id)sender;

@property(nonatomic,assign)float current;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.current = 0;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)tap:(id)sender {
    
    [self.navigationController pushViewController:[[LyViewController alloc] init] animated:YES];
}

@end
