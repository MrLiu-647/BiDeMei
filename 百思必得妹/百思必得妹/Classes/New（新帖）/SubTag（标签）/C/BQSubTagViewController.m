//
//  BQSubTagViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/20.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQSubTagViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BQSubTagItem.h"
#import "BQSubTagCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "BQHttpTool.h"

static NSString * const ID = @"cell";

@interface BQSubTagViewController ()

@property (nonatomic,strong) NSArray *subTags;

@end

@implementation BQSubTagViewController

// 接口文档：请求url（基本url+请求参数）请求方式
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 展示标签数据 -> 请求数据（接口文档）-> 解析数据（写成plist） (image_list，sub_number,theme_name) -> 设计模型 -> 字典转模型 -> 展示数据
    [self loadData];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BQSubTagCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    self.navigationItem.title = @"推荐标签";
    
    /*
        任务：
        1.头像变成圆角：1）设置头像圆角 2）裁剪图片
        2.处理数字
     */
    
    // 处理cell分隔线： 1)自定义分隔线 2)系统属性(iOS8才支持) 3）万能方式（重写cell的setFrame方案）得了解tableView的底层实现  步骤：1.取消系统自带分隔线 2.把tableView背景色设置为分割线的背景色 3.重写setFrame方法
    
    // 分隔线方法二： 系统的方式
//    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    // 分隔线方法三： 万能方式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BQColor(220, 220, 221);
    
    // 提示用户当前正在加载数据 SVProgressHUD
    [SVProgressHUD showWithStatus:@"正在加载中..."];
}

#pragma mark - 请求数据
- (void)loadData {
    // 1.创建请求对象管理者
    AFHTTPSessionManager *manager = [BQHttpTool sharedManager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    // 3.发送请求
    [manager GET:BQCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        BQLog(@"%@",responseObject);
        [SVProgressHUD dismiss];
//        [responseObject writeToFile:@"/Users/Liu/Desktop/百思必得妹/tag.plist" atomically:YES];
        // 字典数组转模型数组
        _subTags = [BQSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss]; 
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // 销毁指示器
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BQSubTagCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 注意：如果cell从xib加载，一定要记得绑定标识符
    // 方法一：注册cell（推荐）
    
    // 方法二：
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BQSubTagCell class]) owner:nil options:nil] lastObject];
//    }
    // 获取模型
    BQSubTagItem *item = self.subTags[indexPath.row];
    cell.item = item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
