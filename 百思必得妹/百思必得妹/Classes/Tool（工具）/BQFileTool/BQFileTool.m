//
//  BQFileTool.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/5.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQFileTool.h"

@implementation BQFileTool

// 计算缓存的大小
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion{
    // NSFileManager：
    // attributesOfItemAtPath:指定文件路径就能获取文件属性 不是文件夹
    // 遍历文件夹中所有文件，再一个一个加起来
    
    // 1.获取文件的管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"You need to pass in the folder path instead of the file path, and the path exists." userInfo:nil];
        [excp raise];
        
    }
    
    // 2.获取文件夹下所有的子路径 （包括子路径的子文件）
    NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger totalSize = 0;    //文件总大小
        
        // 3.遍历所有文件并计算大小
        for (NSString *subPath in subPaths) {
            // 获取文件的全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断一：隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            // 判断二：是否文件夹
            BOOL isDirectory;
            // 判断文件是否存在,并且判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件的属性
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 该文件的尺寸
            NSInteger fileSize = [attr fileSize];
            
            totalSize += fileSize;
        }
        // 计算完成回调
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}

// 删除该路径下的所有文件
+ (void)removeDirectoryAtPath:(NSString *)directoryPath  {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"You need to pass in the folder path instead of the file path, and the path exists." userInfo:nil];
        [excp raise];
    }
    
    // 获取cache文件夹下所有文件,不包括子路径的子文件
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完整的全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除文件
        [mgr removeItemAtPath:filePath error:nil];
    }
}

@end
