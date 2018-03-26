//
//  UIBarButtonItem+item.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/17.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "UIBarButtonItem+item.h"

@implementation UIBarButtonItem (item)

// 普通item
+ (UIBarButtonItem *_Nullable)itemWithImage:(UIImage *_Nonnull)image heighImage:(UIImage *_Nonnull)highImage target:(nullable id)target action:(SEL _Nullable )action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

// 返回按钮
+ (UIBarButtonItem *_Nullable)backItemWithImage:(UIImage *_Nonnull)image heighImage:(UIImage *_Nonnull)highImage target:(nullable id)target action:(SEL _Nullable )action title:(NSString *)title{
    // 设置导航条左边按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);  //设置向左偏移20px
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

// 可选中item
+ (UIBarButtonItem *_Nullable)itemWithImage:(UIImage *_Nonnull)image selectedImage:(UIImage *_Nonnull)selectedImage target:(nullable id)target action:(SEL _Nullable )action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}


@end
