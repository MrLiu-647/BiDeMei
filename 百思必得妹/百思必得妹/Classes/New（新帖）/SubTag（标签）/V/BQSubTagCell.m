//
//  BQSubTagCell.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/22.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQSubTagCell.h"
#import "BQSubTagItem.h"
#import <UIImageView+WebCache.h>

@interface BQSubTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UILabel *numView;

@end

@implementation BQSubTagCell

- (void)setFrame:(CGRect)frame{
//    BQLog(@"%@",NSStringFromCGRect(frame));
    
    // 方法三：万能方法
    frame.size.height -= 1;
    
    // 真正的给cell赋值
    [super setFrame:frame];
}

/*
    头像变成圆角：1）设置头像圆角 2）裁剪图片（生成新的图片 -> 图形上下文才能生成新的图片）
    处理数字dc
 */

- (void)setItem:(BQSubTagItem *)item{
    _item = item;
    //设置内容
    // 1.大标题:
    _nameView.text = item.theme_name;
    // 2.小标题:
    [self resolveSubNum];   //对大于1万的人数进行优化
    
    // 设置头像
    [_iconView bq_setHeader:item.image_list];
    
    // 3.头像: SDWebImage
//    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:SDWebImageCacheMemoryOnly completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        /* 方法二：裁剪图片： 成圆形
         1）开启图形上下文 2）描述裁剪区域 3）设置裁剪区域 4）画图片 5）取出图片 6）关闭上下文
         */
        
//        // 1）开启图形上下文:
//        // 比例因素:当前点与像素比例
//        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
//        // 2）描述裁剪区域
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//        // 3）设置裁剪区域
//        [path addClip];
//        // 4）画图片
//        [image drawAtPoint:CGPointZero];
//        // 5）取出图片
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        // 6）关闭上下文
//        UIGraphicsEndImageContext();
//
//        _iconView.image = image;
//    }];
}

// 从xib中加载就会调用：只调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // 方法一：设置头像圆角，iOS9苹果修复了帧数BUG
//    _iconView.layer.cornerRadius = _iconView.frame.size.height * 0.5;
//    _iconView.layer.masksToBounds = YES;
    
    // 方法二：在xib中用runtime设置
    // ...
    
    // 分隔线方法二：系统的设置cell分隔线置左顶部
//    self.layoutMargins = UIEdgeInsetsZero;
}

// 处理订阅数字 -> 小标题
- (void)resolveSubNum {
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",_item.sub_number];
    NSInteger num = _item.sub_number.integerValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""]; //去掉.0的字符串
    }
    _numView.text = numStr;
    _numView.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
