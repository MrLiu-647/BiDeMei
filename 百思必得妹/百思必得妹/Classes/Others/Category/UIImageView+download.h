//
//  UIImageView+download.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/2.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

@interface UIImageView (download)

- (void)bq_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock;

- (void)bq_setHeader:(NSString *)headerUrl;

@end
