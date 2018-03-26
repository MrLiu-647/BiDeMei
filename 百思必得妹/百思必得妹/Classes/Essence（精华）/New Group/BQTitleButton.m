//
//  BQTitleButton.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/7.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTitleButton.h"

@implementation BQTitleButton

/**
    特定构造方法：
    1> 后面带有NS_DESIGNATED_INITIALIZER的方法就是特定构造方法
    2> 子类如果重写了父类的特定构造方法，就必须用super调用父类的特定构造方法，不然会报警告
 */

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    // 只要重写了set方法，按钮就永远不会达到highlighted状态
}

@end
