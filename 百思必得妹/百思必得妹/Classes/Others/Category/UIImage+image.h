//
//  UIImage+image.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/16.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

+ (UIImage *)imageOriginalWithName:(NSString *)imageName;

- (instancetype)bq_circleImage;

+ (instancetype)bq_circleImageNamed:(NSString *)name;

@end
