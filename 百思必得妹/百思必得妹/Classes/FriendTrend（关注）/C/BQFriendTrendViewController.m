//
//  BQFriendTrendViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/14.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQFriendTrendViewController.h"
#import "BQLoginRegisterViewController.h"

@interface BQFriendTrendViewController ()

@end

@implementation BQFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


// 点击登录注册
- (IBAction)clickLoginRegister:(id)sender {
    BQFunc();
    // 进入到登录注册界面
    BQLoginRegisterViewController *loginVc = [[BQLoginRegisterViewController alloc] init];
    [self presentViewController:loginVc animated:YES completion:^{
        //..
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 设置导航条
- (void)setupNavBar{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] heighImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    
    // 设置titleView
    self.navigationItem.title = @"我的关注";
}

// 推荐关注
- (void)friendsRecomment {
    BQFunc();
}


@end
