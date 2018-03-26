//
//  BQSquareCell.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/3.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQSquareCell.h"
#import <UIImageView+WebCache.h>
#import "BQSquareItem.h"

@interface BQSquareCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;

@end

@implementation BQSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setItem:(BQSquareItem *)item{
    _item = item;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    _nameView.text = item.name;
}

@end
