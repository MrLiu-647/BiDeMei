//
//  BQFileTool.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/5.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

// 用途处理文件缓存
#import <Foundation/Foundation.h>

@interface BQFileTool : NSObject

/**
 * 计算文件夹尺寸
 * @param directoryPath 文件夹路径
 * @param completion 计算完成后的回调
 */
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;



/**
 * 删除该路径下的所有文件
 * @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryAtPath:(NSString *)directoryPath;

@end
