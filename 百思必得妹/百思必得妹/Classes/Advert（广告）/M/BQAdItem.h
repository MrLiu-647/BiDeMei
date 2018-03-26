//
//  BQAdItem.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/19.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <Foundation/Foundation.h>
//  (w_picture,ori_curl:跳转到广告页面,w,h)
@interface BQAdItem : NSObject

/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

@end
