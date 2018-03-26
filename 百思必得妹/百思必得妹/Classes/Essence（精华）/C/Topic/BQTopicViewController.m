//
//  BQTopicViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/19.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQTopicViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/SDImageCache.h>
#import <MJRefresh/MJRefresh.h>

#import "BQTopic.h"
#import "BQTopicCell.h"
#import "BQHttpTool.h"
#import "BQChiBaoZiHeader.h"
#import "BQChiBaoZiFooter.h"

@interface BQTopicViewController ()
/** 描述当前最后一条帖子的信息，方便加载下一页 */
@property (nonatomic,copy) NSString *maxtime;
/** 所有的帖子数据 */
@property (nonatomic,strong) NSMutableArray<BQTopic *> *topics;
/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation BQTopicViewController

// 该方法会被子类重写，这里默认返回图片控制器
- (BQTopicType)type{
    return BQTopicTypePicture;
}

/** cell的重用标识 */
static NSString * const BQTopicCellId = @"BQTopicCell";

- (AFHTTPSessionManager *)manager{
    if (_manager == nil) {
        _manager = [BQHttpTool sharedManager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BQFunc();
    self.view.backgroundColor = BQGrayColor(206);
    
    self.tableView.contentInset = UIEdgeInsetsMake(BQTitlesViewH, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.estimatedRowHeight = 80; //估算tableView的高度为60
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BQTopicCell class]) bundle:nil] forCellReuseIdentifier:BQTopicCellId];
    
    // 响应通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:BQTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBtnRepeatClick) name:BQTitleButtonDidRepeatClickNotification object:nil];
    
    [self setupRefresh];    //设置刷新控件
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 设置刷新控件
- (void)setupRefresh {
    // 广告条
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, 0, 30);
    label.textColor = [UIColor whiteColor];
    label.text = @"广告";
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = label;
    
    // header
    self.tableView.mj_header = [BQChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // footer
    self.tableView.mj_footer = [BQChiBaoZiFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 监听
// 监听tabbBtn重复点击
- (void)tabBarBtnRepeatClick {
    BQFunc();
    if (self.view.window == nil) {return;}  //如果当前控制器的view不在window上，代表不是重复点的精华，返回
    
    if (self.tableView.scrollsToTop == NO) {return;}    //代表不是all在当前的界面 返回
    
    [self.tableView.mj_header beginRefreshing]; //进入下拉刷新
}

// 监听titleBtn重复点击
- (void)titleBtnRepeatClick {
    [self tabBarBtnRepeatClick];
}

#pragma mark - 数据处理

/**
 *   发送请求给服务器，下拉刷新新数据
 */
- (void)loadNewData {
    BQLog(@"发送请求给服务器，下拉刷新数据...");
    
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager]; // 1.创建afn管理者
    
    //    [self.manager invalidateSessionCancelingTasks:YES]; // 取消所有的请求，并且关闭session（注意：一旦关闭了session，这个manager再也无法发送任何请求）
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];  // 1.取消之前的请求
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary]; // 2.拼接参数
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);   // 这里发送@1也是可行的
    
    [self.manager GET:BQCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BQLog(@"请求成功 ---- %@",responseObject);
        self.maxtime = responseObject[@"info"][@"maxtime"];     //存储maxtime
        self.topics = [BQTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];   // 字典数组 -> 模型数据
        
        //        NSMutableArray *newTopics = [BQTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];   // 字典数组 -> 模型数据
        //        if (self.topics) {
        //            [self.topics insertObjects:newTopics atIndexes:[NSIndexSet indexSetWithIndex:0]];   //新数据到第一个位置
        //        } else {    // 没有数据就直接赋值
        //            self.topics = newTopics;
        //        }
        
        
        [self.tableView reloadData];    // 刷新表格
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BQLog(@"请求失败 ---- %@",error);
        if (error.code != NSURLErrorCancelled) {
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
        
        [self.tableView.mj_header endRefreshing];     // 结束刷新
    }]; // 3.发送请求
}

/**
 *   发送请求给服务器，上拉刷新更多数据
 */
- (void)loadMoreData {
    // 发送请求给服务器
    BQLog(@"发送请求给服务器 - 加载更多数据");
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];  // 1.取消之前的请求
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary]; // 2.拼接参数
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);// 这里发送@1也是可行的
    parameters[@"maxtime"] = self.maxtime;
    
    [self.manager GET:BQCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BQLog(@"请求成功 ---- %@",responseObject);
        BQAFNWriteToPlist(newData);
        self.maxtime = responseObject[@"info"][@"maxtime"];//存储最后一贴的maxtime
        NSArray *moreTopics = [BQTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];// 字典数组->模型数据
        [self.topics addObjectsFromArray:moreTopics];// 添加数据
        
        [self.tableView reloadData];// 刷新表格
        
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BQLog(@"请求失败 ---- %@",error);
        if (error.code != NSURLErrorCancelled) {// 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试!"];
        }
        
        [self.tableView.mj_footer endRefreshing];
    }]; // 3.发送请求
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView :(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // control + command + 空格 -> 弹出emoji表情键盘
    //    cell.textLabel.text = @"⚠️哈哈";
    
    BQTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BQTopicCellId];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
/*
 使用estimatedRowHeight的优缺点
 1.优点
 1> 可以降低tableView:heightForRowAtIndexPath:方法的调用频率
 2> 将【计算cell高度的操作】延迟执行了（相当于cell高度的计算是懒加载的）
 
 2.缺点
 1> 滚动条长度不准确、不稳定，甚至有卡顿效果（如果不使用estimatedRowHeight，滚动条的长度就是准确的）
 */

/**
 这个方法的特点：
 1.默认情况下
 1> 每次刷新表格时，有多少数据，这个方法就一次性调用多少次（比如有100条数据，每次reloadData时，这个方法就会一次性调用100次）
 2> 每当有cell进入屏幕范围内，就会调用一次这个方法
 
 2.设置estimatedRowHeight的情况下
 1> 用到了（显示了）哪个cell，才会调用这个方法计算那个cell的高度（方法调用频率降低了）
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.topics[indexPath.row].cellHeight;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[SDImageCache sharedImageCache] clearMemory];  //清除缓存
}

@end
