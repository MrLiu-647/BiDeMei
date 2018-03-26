//
//  BQTopic.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/22.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTopic.h"

@implementation BQTopic

- (CGFloat)cellHeight {
    if (_cellHeight) {  //有值之后 直接返回
        return _cellHeight;
    }
    
    _cellHeight = 2 * BQMargin + 35;    //上部分固定的长度
    
    CGSize textMaxSize = CGSizeMake(BQScreenW - 2 * BQMargin, MAXFLOAT);//每一行的最大宽度
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size.height + BQMargin;  //加上文字的高度
    
    // 中间的内容
    if (self.type != BQTopicTypeWord) { // 中间有内容（图片、声音、视频）
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= BQScreenH) { // 图片过长 需要优化显示
            middleH = 220;
            self.bigPicture = YES;
        }
        CGFloat middleX = 10;
        CGFloat middleY = _cellHeight;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        
        _cellHeight += middleH + BQMargin;
    }
    
    // 最热评论
    if (self.top_cmt.count) { // 有最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + BQMargin * 0.5;
    }
    
    _cellHeight += 35 + BQMargin * 0.5; //下部分固定的长度
    
    return _cellHeight;
}

@end
