//
//  BQHttpTool.h
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/20.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface BQHttpTool : NSObject

+ (AFHTTPSessionManager *)sharedManager;

@end
