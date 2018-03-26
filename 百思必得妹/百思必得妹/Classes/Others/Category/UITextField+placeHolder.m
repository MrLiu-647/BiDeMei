//
//  UITextField+placeHolder.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/1.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "UITextField+placeHolder.h"
#import <objc/message.h>

@implementation UITextField (placeHolder)

// 利用runtime交换方法的方法
+ (void)load{
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setBq_PlaceholderMethod = class_getInstanceMethod(self, @selector(setBq_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setBq_PlaceholderMethod);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    // 给成员属性赋值 runtime给系统的类添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   // 添加成员属性
    
    // 获取占位文字控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}

- (UIColor *)placeholderColor{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
- (void)setBq_Placeholder:(NSString *)placeholder {
    [self setBq_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

@end
