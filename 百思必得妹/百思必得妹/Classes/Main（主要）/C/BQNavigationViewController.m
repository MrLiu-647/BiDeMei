//
//  BQNavigationViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/18.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQNavigationViewController.h"

@interface BQNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BQNavigationViewController

+ (void)load {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    // 设置导航条标题 => UINavigationBar 注意：只要是通过模型设置，都是通过富文本设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 全屏滑动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];  // 调用了系统的滑动方法，怎么实现的？谁知道呢..
    
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
    
    // 禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
//    self.interactivePopGestureRecognizer.delegate = self;
    
//    UIScreenEdgePanGestureRecognizer *edgePan = self.interactivePopGestureRecognizer;
//    edgePan.edges = UIRectEdgeNone;
}

#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 只有非根控制器才需要触发手势
    return (self.childViewControllers.count > 1);
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    BQFunc();
    
    if (self.childViewControllers.count > 0) {  // 非根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置返回按钮，只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] heighImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }

    //真正的跳转
    [super pushViewController:viewController animated:animated];
}

// 回退
- (void)back{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
