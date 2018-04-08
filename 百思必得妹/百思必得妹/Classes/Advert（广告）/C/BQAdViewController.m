//
//  BQAdViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/18.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQAdViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BQAdItem.h"
#import <UIImageView+WebCache.h>
#import "BQTabBarController.h"
#import "BQHttpTool.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"


@interface BQAdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LaunchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property (weak, nonatomic) UIImageView *adView;
@property (strong,nonatomic) BQAdItem *item;
@property (weak, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;

@end

@implementation BQAdViewController

- (UIImageView *)adView {
    if (_adView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.adContainView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        
        _adView = imageView;
    }
    return _adView;
}

// 点击广告页面调用
- (void)tap {
    // 跳转到界面 safari
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url options:@{} completionHandler:^(BOOL success) {
            BQLog(@"成功打开广告下载页面");
        }];
    }

}

// 点击跳转做的事情
- (IBAction)jumpClick:(id)sender {
    BQTabBarController *tabBarVc = [[BQTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;

    // 销毁定时器
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置启动图片
    [self setupLaunchImage];
    // 2.加载广告数据 ==> 拿到活的数据 => 服务器 -> 查看接口文档 : 1.判断接口对不对 2.解析数据(w_picture,ori_curl:跳转到广告页面,w,h) => 请求数据（AFN）
    [self loadAdData];
    // 3.创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

- (void)timeChange {
    // 倒计时
    static int i = 3;
    i--;
    // 设置跳转按钮文字
    [_jumpBtn setTitle:[NSString stringWithFormat:@"跳转（%d）",i] forState:UIControlStateNormal];
    
    if (i == 0) {
        [self jumpClick:nil];
    }
}

/*
 http://mobads.baidu.com/cpro/ui/mads.php?code2=phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam
 */

#pragma mark - 加载广告数据
- (void)loadAdData {
    // "Request failed: unacceptable content-type: text/html" 响应头错误
    // 1.创建请求对话管理者
    AFHTTPSessionManager *manager = [BQHttpTool sharedManager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    
    // 3.发送请求
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject writeToFile:@"/Users/Liu/Desktop/百思必得妹/ad.plist" atomically:YES];
        BQLog(@"%@",responseObject);
        /*****************************************************************************
             成功：请求数据 -> 解析数据（写成plist文件）-> 设计模型 -> 字典转模型 -> 显示数据
         *****************************************************************************/
        
        // 获取字典
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        
        // 字典转模型
        _item = [BQAdItem mj_objectWithKeyValues:adDict];
        
        if (_item != nil) {
            // 创建UIImageView展示图片 =>
            CGFloat h = BQScreenW / _item.w * _item.h;
            
            self.adView.frame = CGRectMake(0, 0, BQScreenW, h);
            // 加载广告网页
            [self.adView sd_setImageWithURL:[NSURL URLWithString:_item.w_picurl]];  
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BQLog(@"%@",error);
    }];
}

// 设置启动图片
- (void)setupLaunchImage {
    // 屏幕的适配
#warning 屏幕适配..待优化..
    if (iPhone6p) { // 6p、7p
        self.LaunchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iPhone6){    // 6、7、8
        self.LaunchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    }else if (iPhone5){    // 5
        self.LaunchImageView.image = [UIImage imageNamed:@"LaunchImage-568h"];
    }else if (iPhone4){    // 4
        self.LaunchImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
    }else {
        self.LaunchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
