//
//  BQTopicCell.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/23.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQTopic;

@interface BQTopicCell : UITableViewCell
/** 模型数据 */
@property (nonatomic,strong) BQTopic *topic;
@end
