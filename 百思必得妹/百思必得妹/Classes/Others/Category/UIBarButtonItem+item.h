//
//  UIBarButtonItem+item.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/17.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (item)
// 快速创建UIBarButtonItem对象
+ (UIBarButtonItem *_Nullable)itemWithImage:(UIImage *_Nonnull)image heighImage:(UIImage *_Nonnull)highImage target:(nullable id)target action:(SEL _Nullable )action;

+ (UIBarButtonItem *_Nullable)backItemWithImage:(UIImage *_Nonnull)image heighImage:(UIImage *_Nonnull)highImage target:(nullable id)target action:(SEL _Nullable )action title:(NSString *_Nullable)title;

+ (UIBarButtonItem *_Nullable)itemWithImage:(UIImage *_Nonnull)image selectedImage:(UIImage *_Nonnull)selectedImage target:(nullable id)target action:(SEL _Nullable )action;

@end
