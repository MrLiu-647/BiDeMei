//
//  UIView+frame.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/17.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

+ (instancetype)bq_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setBq_width:(CGFloat)bq_width{
    CGRect rect = self.frame;
    rect.size.width = bq_width;
    self.frame = rect;
}

- (void)setBq_height:(CGFloat)bq_height{
    CGRect rect = self.frame;
    rect.size.height = bq_height;
    self.frame = rect;
}

- (void)setBq_x:(CGFloat)bq_x{
    CGRect rect = self.frame;
    rect.origin.x = bq_x;
    self.frame = rect;
}

- (void)setBq_y:(CGFloat)bq_y{
    CGRect rect = self.frame;
    rect.origin.y = bq_y;
    self.frame = rect;
}

- (void)setBq_centerX:(CGFloat)bq_centerX{
    CGPoint center = self.center;
    center.x = bq_centerX;
    self.center = center;
}

- (void)setBq_centerY:(CGFloat)bq_centerY{
    CGPoint center = self.center;
    center.y = bq_centerY;
    self.center = center;
}

- (CGFloat)bq_width{
    return self.frame.size.width;
}

- (CGFloat)bq_height{
    return self.frame.size.height;
}

- (CGFloat)bq_x{
    return self.frame.origin.x;
}

- (CGFloat)bq_y{
    return self.frame.origin.y;
}

- (CGFloat)bq_centerX{
    return self.center.x;
}

- (CGFloat)bq_centerY{
    return self.center.y;
}
@end
