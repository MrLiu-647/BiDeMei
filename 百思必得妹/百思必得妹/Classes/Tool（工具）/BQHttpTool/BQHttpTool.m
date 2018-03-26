//
//  BQHttpTool.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/20.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQHttpTool.h"

@implementation BQHttpTool
static AFHTTPSessionManager *manager;

+ (AFHTTPSessionManager *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化请求管理类
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置15秒超时 - 取消请求
        manager.requestSerializer.timeoutInterval = 15.0;
        // 编码
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        // 缓存策略
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        // 支持内容格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    });
    return manager;
    
}

@end
