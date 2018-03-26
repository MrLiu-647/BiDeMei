//
//  BQTabBar.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/17.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTabBar.h"
#import "UIView+frame.h"

@interface BQTabBar ()

@property (nonatomic,weak) UIButton *plusButton;
// 上一次点击的tabBarButton
@property (nonatomic,weak) UIControl *previousClickedTabBarButton;

@end

@implementation BQTabBar

- (UIButton *)plusButton{
    if (_plusButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [self addSubview:btn];
        
        _plusButton = btn;
    }
    return _plusButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 跳转tabBarButton位置
    CGFloat btnW = self.bq_width / (self.items.count + 1);
    CGFloat btnH = BQTabBarH;
    CGFloat x = 0;
    int i = 0;
    // 私有类：打印出来有个类，但是敲出来没有 说明这个类是系统私有类
    // 遍历子控件 调整布局
    for (UIControl *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 设置previousClickedTabBarButton的默认值为第0个按钮
            if (i == 0 && self.previousClickedTabBarButton == nil) {
                self.previousClickedTabBarButton = tabBarButton;
            }
            
            if (i == 2) {
                i++;
            }
            x = i * btnW;
            
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH);
            
            i++;
            
            // UIControlEventTouchDownRepeat : 在短时间内连续点击按钮
            
            // 监听点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    // 调整发布按钮位置
    self.plusButton.center = CGPointMake(self.bq_width * 0.5 , BQTabBarH * 0.5);
}

// tabBarBtn的点击
- (void)tabBarButtonClick:(UIControl *)tabBarButton {
    if (tabBarButton == self.previousClickedTabBarButton) {
        BQFunc();
        // 发布tabBar通知，告诉外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:BQTabBarButtonDidRepeatClickNotification object:nil];
    }
    self.previousClickedTabBarButton = tabBarButton;
}

@end
