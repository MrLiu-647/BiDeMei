//
//  BQLoginRegisterView.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/28.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQLoginRegisterView.h"

@interface BQLoginRegisterView()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;

@end

// 越复杂的界面，需要封装。 有特殊效果的界面，也需要封装。

@implementation BQLoginRegisterView

+ (instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+ (instancetype)registerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *bg = _loginRegisterBtn.currentBackgroundImage;
    bg = [bg stretchableImageWithLeftCapWidth:bg.size.width * 0.5 topCapHeight:bg.size.height * 0.5];
    
    // 让图片不要拉伸
    [_loginRegisterBtn setBackgroundImage:bg forState:UIControlStateNormal];
}
@end
