//
//  UIImageView+download.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/2.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "UIImageView+download.h"
#import <AFNetworkReachabilityManager.h>
#import <UIImageView+WebCache.h>

@implementation UIImageView (download)

- (void)bq_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock
{
    //    [[SDWebImageManager sharedManager]setCacheKeyFilter:^(NSURL *url) {
    //        // 所有缓存图片的key后面都有个-bq后缀
    //        return [NSString stringWithFormat:@"%@-bq", url.absoluteString];
    //    }];
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if (originImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
        } else if (mgr.isReachableViaWWAN) {
#warning downloadOriginImageWhen3GOr4G配置项的值需要从沙盒里面获取
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            } else { // 没有下载过任何图片
                // 占位图片;
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completedBlock];
            }
        }
    }
}

- (void)bq_setHeader:(NSString *)headerUrl
{
    UIImage *placeholder = [UIImage bq_circleImageNamed:@"defaultUserIcon"];
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回，按照它的默认做法
        if (!image) return;
        
        self.image = [image bq_circleImage];
    }];
    
//    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
