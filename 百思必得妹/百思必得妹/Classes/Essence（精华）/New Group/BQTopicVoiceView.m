//
//  BQTopicVoiceView.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/26.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTopicVoiceView.h"
#import "BQTopic.h"
#import "BQSeeBigPictureViewController.h"

@interface BQTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;

@end

@implementation BQTopicVoiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
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
    [self.imageView bq_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderView.hidden = YES;
    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放",topic.playcount/10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",topic.voicetime / 60,topic.voicetime % 60];
}

@end
