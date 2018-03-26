//
//  BQFastLoginBtn.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/30.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQFastLoginBtn.h"

@implementation BQFastLoginBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 设置图片的位置
    self.imageView.bq_centerX = self.bq_width * 0.5;
    self.imageView.bq_y = 0;

    // 计算文字宽度,再给label的宽度赋值
    [self.titleLabel sizeToFit];
    // 设置标题的位置
    self.titleLabel.bq_centerX = self.bq_width * 0.5;
    self.titleLabel.bq_y = self.bq_height - self.titleLabel.bq_height;
    
    

}

@end
