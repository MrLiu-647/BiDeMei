//
//  BQFastLoginView.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/30.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQFastLoginView.h"

@implementation BQFastLoginView

+ (instancetype)fastLoginView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
