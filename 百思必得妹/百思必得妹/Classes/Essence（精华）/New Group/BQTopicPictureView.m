//
//  BQTopicPictureView.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/26.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTopicPictureView.h"
#import "BQTopic.h"
#import <FLAnimatedImageView.h>
#import <FLAnimatedImageView+WebCache.h>
#import "BQSeeBigPictureViewController.h"

@interface BQTopicPictureView()

@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation BQTopicPictureView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

- (IBAction)seeBigPictureBtnClick:(id)sender {
    [self seeBigPicture];
}

/**
    查看大图
 */
- (void)seeBigPicture {
    BQSeeBigPictureViewController *vc = [[BQSeeBigPictureViewController alloc] init];
    vc.topic = self.topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

- (void)setTopic:(BQTopic *)topic {
    _topic = topic;
    
    // 设置图片
    self.placeholderView.hidden = NO;
//    [self.imageView bq_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (!image) return;
//
//        self.placeholderView.hidden = YES;
//
//        // 处理超长图片的大小
//        if (topic.isBigPicture) {
//            CGFloat imageW = topic.middleFrame.size.width;
//            CGFloat imageH = imageW * topic.height / topic.width;
//
//            // 开启上下文
//            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
//            // 绘制图片到上下文中
//            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
//            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//            // 关闭上下文
//            UIGraphicsEndImageContext();
//        }
//    }];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image0] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.placeholderView.hidden = YES;

        // 处理超长图片的大小
        if (topic.isBigPicture) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;

            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    }];
    
    // gif
    self.gifView.hidden = !topic.is_gif;
    
    // 点击查看大图
    if (topic.isBigPicture) {   // 是超长图
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    } else {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}

@end
