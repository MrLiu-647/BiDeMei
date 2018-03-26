//
//  BQTopicCell.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/23.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTopicCell.h"
#import "BQTopic.h"
#import <UIImageView+WebCache.h>

#import "BQTopicVideoView.h"
#import "BQTopicVoiceView.h"
#import "BQTopicPictureView.h"

@interface BQTopicCell()
// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;

// 中间控件
@property (nonatomic, weak) BQTopicVideoView *videoView;
@property (nonatomic, weak) BQTopicVoiceView *voiceView;
@property (nonatomic, weak) BQTopicPictureView *pictureView;
@end

@implementation BQTopicCell

- (BQTopicVideoView *)videoView {
    if (_videoView == nil) {
        BQTopicVideoView *videoView = [BQTopicVideoView bq_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (BQTopicVoiceView *)voiceView {
    if (_voiceView == nil) {
        BQTopicVoiceView *voiceView = [BQTopicVoiceView bq_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (BQTopicPictureView *)pictureView {
    if (_pictureView == nil) {
        BQTopicPictureView *pictureView = [BQTopicPictureView bq_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    
    // 设置头像圆角
//    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height * 0.5;
//    self.profileImageView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.topic.type == BQTopicTypeVideo) {  //视频
        self.videoView.frame = self.topic.middleFrame;
    }else if (self.topic.type == BQTopicTypeVoice) {    //声音
        self.voiceView.frame = self.topic.middleFrame;
    }else if (self.topic.type == BQTopicTypePicture) {  //图片
        self.pictureView.frame = self.topic.middleFrame;
    }else if (self.topic.type == BQTopicTypeWord) { //文字
        
    }
}

- (void)setTopic:(BQTopic *)topic {
    _topic = topic;
    
    // 顶部控件的数据
    [self.profileImageView bq_setHeader:topic.profile_image];
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    // 底部按钮的文字
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placeholder:@"评论"];
    
    // 最热评论
    if (topic.top_cmt.count) { // 有最热评论
        self.topCmtView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.topCmtView.hidden = YES;
    }
    
    // 中间的内容
    if (topic.type == BQTopicTypeVideo) {
        self.videoView.topic = topic;
        self.videoView.hidden = NO;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    } else if (topic.type == BQTopicTypeVoice){
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
    } else if (topic.type == BQTopicTypePicture){
        self.pictureView.topic = topic;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = NO;
    } else if (topic.type == BQTopicTypeWord){
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
}

/**
 设置按钮文字
 @param button 赋值的按钮
 @param number 按钮的数字
 @param placeholder 数字为0时显示的文字
 */
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder {
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@" %.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@" %zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= BQMargin * 0.5;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
