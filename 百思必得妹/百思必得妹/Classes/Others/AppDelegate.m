//
//  AppDelegate.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/14.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "AppDelegate.h"
#import "BQAdViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <KTVHTTPCache/KTVHTTPCache.h>

/**
    优先级：LaunchScreen > LaunchImage
    配置前需要清空缓存 command+shift+k 或者 删除程序，重新生成
    如果设置了LaunchImage 那么程序的启动图片的尺寸适配问题 全由图片决定，注：此时，美工必须做所有尺寸的图片
 
    Xcode6开始支持LaunchScreen
    优点：1、自动识别当前真机或者模拟器的尺寸
         2、让美工做一个可拉伸的图片就可以了
         3、可以展示更多的东西
 
    LaunchScreen的底层实现：
    把LaunchScreen截屏，生成一张图片，作为启动界面
 */

/**
    项目架构（结构）搭建：UI层 - 数据层 - 请求层
    主流结构：UITabBarController + UINavigationController
    -> 项目UI开发方式 1.storyboard 2.纯代码
 */

// 每次程序启动的时候进入广告界面
// 1.每次程序启动的时候，加个广告界面
// 2.启动完成的时候，加个广告界面（展示了启动界面）
/*
    1）程序一启动就进入广告界面，窗口的根控制器设置为广告控制器
    2）直接往窗口上再加上一个广告界面，等几秒钟过去了，再把广告界面移除
 */

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - <UIApplicationDelegate>
// 程序启动的时候就会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    BQAdViewController *adVc = [[BQAdViewController alloc] init];
    self.window.rootViewController = adVc;
    
    // 开始监控网络状况
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 启动KTV缓存框架
    NSError * error;
    [KTVHTTPCache proxyStart:&error];
    if (error) {
        NSLog(@"Proxy Start Failure, %@", error);
    } else {
        NSLog(@"Proxy Start Success");
    }
    
    return YES;
}

// 禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
