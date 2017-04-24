//
//  LyViewController.m
//  LyRefreshDemo
//
//  Created by 张杰 on 2017/4/24.
//  Copyright © 2017年 张杰. All rights reserved.
//

#import "LyViewController.h"
#import "ViewController.h"

@interface LyViewController ()

- (IBAction)btnclick:(id)sender;
@end

@implementation LyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)btnclick:(id)sender {
    
    [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
}
@end
