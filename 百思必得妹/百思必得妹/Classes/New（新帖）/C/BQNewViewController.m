//
//  BQNewViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/15.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQNewViewController.h"
#import "BQSubTagViewController.h"

@interface BQNewViewController ()

@end

@implementation BQNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    [self setupNavBar];
    
    // 响应通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:BQTabBarButtonDidRepeatClickNotification object:nil];
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
// 监听tabbBtn重复点击
- (void)tabBarBtnRepeatClick {
    BQFunc();
    if (self.view.window == nil) {return;}
    
    BQLog(@"%@ -- reload Data",self.class);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 设置导航条

- (void)setupNavBar{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] heighImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(tagClick)];

    // 设置titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

#pragma mark - 点击订阅标签调用
// 新帖标签
- (void)tagClick {
    BQFunc();
    // 进入推荐标签界面
    BQSubTagViewController *subTagVc =[[BQSubTagViewController alloc] init];
    
    [self.navigationController pushViewController:subTagVc animated:YES];
}

@end
