//
//  UIImage+image.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/16.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "UIImage+image.h"

@implementation UIImage (image)

// 设置图片
+ (UIImage *)imageOriginalWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)bq_circleImage
{
    // 1.开启图形上下文
    // 比例因素:当前点与像素比例
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 2.描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 3.设置裁剪区域;
    [path addClip];
    // 4.画图片
    [self drawAtPoint:CGPointZero];
    // 5.取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)bq_circleImageNamed:(NSString *)name
{
    return [[self imageNamed:name] bq_circleImage];
}

@end
