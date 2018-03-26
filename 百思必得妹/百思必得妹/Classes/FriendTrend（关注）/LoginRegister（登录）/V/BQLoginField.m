//
//  BQLoginField.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/1.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQLoginField.h"
#import "UITextField+placeHolder.h"

@implementation BQLoginField

/*
 1.文本框光标变成白色
 2.文本框开始编辑的时候，占位文字颜色变成白色
 */

- (void)awakeFromNib {
    [super awakeFromNib];
    //  1.文本框光标变成白色
    self.tintColor = [UIColor whiteColor];
    //  2.监听文本框编辑：1）代理 2）通知 3）target
    //  原则：自己不要成为自己的代理
    //  通知：一对多
    
    // 开始编辑
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    // 结束编辑
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    // 快速设置占位文字颜色 => 文本框占位文字可能是label => 验证占位文字是label => 拿到label => 查看label属性名（1.runtime 2.断点）
    
    // 获取占位文字控件
    self.placeholderColor = [UIColor lightGrayColor];
}

// 文本框开始编辑调用
- (void)textBegin {
    // 设置占位文字颜色变成白色
    self.placeholderColor = [UIColor whiteColor];
}

// 文本框结束编辑调用
- (void)textEnd {
    self.placeholderColor = [UIColor lightGrayColor];
}

@end
