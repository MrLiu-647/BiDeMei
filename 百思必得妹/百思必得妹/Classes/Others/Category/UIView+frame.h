//
//  UIView+frame.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/17.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

@property CGFloat bq_width;
@property CGFloat bq_height;
@property CGFloat bq_x;
@property CGFloat bq_y;
@property CGFloat bq_centerX;
@property CGFloat bq_centerY;

+ (instancetype)bq_viewFromXib;

@end
