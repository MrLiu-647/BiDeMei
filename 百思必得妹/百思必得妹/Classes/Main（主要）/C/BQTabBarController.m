//
//  BQTabBarController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/15.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTabBarController.h"
#import "BQEssenceViewController.h"
#import "BQNewViewController.h"
#import "BQFriendTrendViewController.h"
#import "BQMeTableViewController.h"

#import "BQNavigationViewController.h"

#import "BQTabBar.h"
#import "UIImage+image.h"

@interface BQTabBarController ()

@end

@implementation BQTabBarController

// 只会调用一次
+ (void) load{
    /*
     appearance :
     注意：
     1. 只要遵循了UIAppearance协议，还要实现这个方法
     2. 那些属性可以通过appearance设置，只有被UI_APPEARENCE_SELECTOR宏修饰的属性，才能设置
     */
    
    // 获取整个应用下的UITabBarItem
//    UITabBarItem *item = [UITabBarItem appearance];
    // 获取当前类的UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    // 设置按钮选中标题的颜色：富文本：描述一个文字颜色、字体、阴影、空心、图文混排
    // 创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸：只有在正常状态下才会有用
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

/*
    问题：
    1. 选中按钮的图片被渲染 -> iOS7 之后默认tabBar上按钮图片都会被渲染 1）修改图片 2）通过代码
    2. 选中标题颜色：黑色 标题字体大 -> 对应子控制器的tabBarItem
    3. 发布按钮显示不出来
 
    最终方案：跳转到系统tabBar上按钮的位置，平均分成五等份，再把加号显示在中间
    调整系统自带控件的子控件的位置 => 自定义tabBar => 使用tabBar
 
 */
#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // 2.1 添加子控制器（5个子控制器）-> 自定义控制器 -> 划分项目文件的结构
    [self setUpAllChildViewControllers];
    
    // 2.2 设置tabBar按钮的内容 ： 由对应的子控制器的tabBarItem属性决定
    [self setUpAllTitleButton];
    
    // 2.3 自定义tabBar
    [self setUpTabBar];
}

#pragma mark - 设置子控制器
- (void)setUpAllChildViewControllers{
    // 精华
    BQEssenceViewController *essenceVc = [[BQEssenceViewController alloc] init];
    BQNavigationViewController *nav = [[BQNavigationViewController alloc] initWithRootViewController:essenceVc];
    // tabBarVc会把第1个子控制器的view添加进去
    [self addChildViewController:nav];
    
    // 新帖
    BQNewViewController *newVc = [[BQNewViewController alloc] init];
    BQNavigationViewController *nav1 = [[BQNavigationViewController alloc] initWithRootViewController:newVc];
    // tabBarVc会把第2个子控制器的view添加进去
    [self addChildViewController:nav1];
    
    // 关注
    BQFriendTrendViewController *friendTrendVc = [[BQFriendTrendViewController alloc] init];
    BQNavigationViewController *nav3 = [[BQNavigationViewController alloc] initWithRootViewController:friendTrendVc];
    // tabBarVc会把第4个子控制器的view添加进去
    [self addChildViewController:nav3];
    
    // 我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([BQMeTableViewController class]) bundle:nil];
    BQMeTableViewController *meVc = [storyboard instantiateInitialViewController];//加载箭头指向的Controller
    BQNavigationViewController *nav4 = [[BQNavigationViewController alloc] initWithRootViewController:meVc];
    // tabBarVc会把第5个子控制器的view添加进去
    [self addChildViewController:nav4];
}

#pragma mark - 设置按钮标题
- (void) setUpAllTitleButton{
    // 0: 精华
    BQNavigationViewController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"精华";
    nav.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    
    // 1: 新帖
    BQNavigationViewController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"新帖";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon"];
    
    // 2: 发布 === 自定义tabBar
    
    // 3: 关注
    BQNavigationViewController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    // 4: 我
    BQNavigationViewController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];
}

#pragma mark - 自定义tabBar
- (void) setUpTabBar {
    BQTabBar *tabBar = [[BQTabBar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];

//    BQLog(@"%@",self.tabBar);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
