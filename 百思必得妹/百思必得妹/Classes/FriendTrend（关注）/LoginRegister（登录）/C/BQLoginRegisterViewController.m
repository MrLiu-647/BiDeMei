//
//  BQLoginRegisterViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/27.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQLoginRegisterViewController.h"
#import "BQLoginRegisterView.h"
#import "BQFastLoginView.h"
 
@interface BQLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation BQLoginRegisterViewController
// 1.划分结构（顶部，中间，底部）
// 2.一个结构一个结构去做：越复杂的界面越要去封装（复用）

/*
    屏幕适配问题：
    1. 一个view从xib加载，需不需要再重新固定尺寸？ => 需要
    2. 再viewDidLoad中设置frame好不好？ => 不好，开发中一般在viewDidLayoutSubviews中去布局子控件
 */

// 返回按钮
- (IBAction)close:(id)sender {
    BQFunc();
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 注册账号
- (IBAction)clickRegister:(UIButton *)sender {
    BQFunc();
    sender.selected = !sender.selected;
    
    // 平移中间的View
    self.leadCons.constant = self.leadCons.constant == 0? - self.middleView.bq_width * 0.5 : 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建登录View
    BQLoginRegisterView *loginView = [BQLoginRegisterView loginView];
    // 添加中间的View
    [self.middleView addSubview:loginView];

    // 创建注册View
    BQLoginRegisterView *registerView = [BQLoginRegisterView registerView];
    // 添加中间的View
    [self.middleView addSubview:registerView];
    
    // 创建快速登录View
    BQFastLoginView *fastLoginView = [BQFastLoginView fastLoginView];
    // 添加到底部的View
    [self.bottomView addSubview:fastLoginView];
    
    /*
        1.文本框光标变成白色
        2.文本框开始编辑的时候，占位文字颜色变成白色
     */
}

// 该方法会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews {
    // 设置登录按钮frame
    self.middleView.subviews[0].frame = CGRectMake(0, 0, self.middleView.bq_width * 0.5, self.middleView.bq_height);
    // 设置注册按钮frame
    self.middleView.subviews[1].frame = CGRectMake(self.middleView.bq_width * 0.5, 0, self.middleView.bq_width * 0.5, self.middleView.bq_height);
    // 设置快速登录frame
    self.bottomView.subviews.firstObject.frame = self.bottomView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
