 //
//  BQMeTableViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/14.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQMeTableViewController.h"
#import "BQSettingViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BQSquareItem.h"
#import "BQSquareCell.h"
#import <SafariServices/SafariServices.h>   //iOS9+ SFSafariViewController
#import <WebKit/WebKit.h>   //iOS8+ WKWebView
#import "BQWebViewController.h"
#import "BQHttpTool.h"

/*
    搭建基本结构 -> 设置底部条 -> 设置顶部条 -> 设置顶部条标题字体 -> 处理导航控制器业务逻辑（跳转）
 */

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1;
#define itemWH (BQScreenW - (cols -1) * margin) / cols

@interface BQMeTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SFSafariViewControllerDelegate>
@property (nonatomic,strong) NSMutableArray *squareItems;
@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation BQMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航条
    [self setupNavBar];
    
    // 2.设置tableView底部视图
    [self setupFootView];
    
    // 3.展示方块内容 -> 请求数据（查看接口文档）
    [self loadData];
    
    /*
        跳转细节：resolveData方法已解决
        1.collectionView高度重新计算  => 需要根据内容去计算  => 有数据了再计算一下高度
        2.collectionView不需要滚动
     */
    
    // 4.处理cell间距，默认tableView分组样式有额外的头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BQMargin;
    
    self.tableView.contentInset = UIEdgeInsetsMake(BQMargin - BQTitlesViewH, 0, 0, 0);
    
    // 响应通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarBtnRepeatClick) name:BQTabBarButtonDidRepeatClickNotification object:nil];
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听
// 监听tabbBtn重复点击
- (void)tabBarBtnRepeatClick {
    BQFunc();
    if (self.view.window == nil) {return;}
    
    BQLog(@"%@ -- reload Data",self.class);
}


#pragma mark - 请求数据
- (void)loadData {
    // 1.创建请求会话管理者
    AFHTTPSessionManager *manager = [BQHttpTool sharedManager];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [manager GET:BQCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dictArr = responseObject[@"square_list"];
        // 字典数组转模型
        self.squareItems = [BQSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        // 处理完成数据：缺块补充
        [self resolveData];
        
        // 设置collectionView 计算collectionView高度 = 多少行 * 每一行的一个高度 = rows * itemWH
        // 公式：Rows = (count - 1) / cols + 1
        NSInteger count = self.squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        // 设置collectionView的高度
        self.collectionView.bq_height = rows * itemWH;
        // 设置UITableView的滚动范围:自动计算
        self.tableView.tableFooterView = self.collectionView;
        
        // 刷新表格
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BQLog(@"%@",error);
    }];
}

#pragma mark - 处理请求完成的数据
- (void)resolveData {
    // 缺块填充
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if (exter) {
        exter = cols - exter;
        for (int i = 0; i < exter ; i++) {
            BQSquareItem *item = [[BQSquareItem alloc] init];
            [self.squareItems addObject:item];
        }
    }
}

#pragma mark - 设置tableView底部视图
- (void)setupFootView {
    /*
        1.初始化要设置流水布局
        2.cell必须要注册
        3.cell必须自定义
     */
    // 创建布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // 设置cell的尺寸
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = margin; // 最小线间距
    layout.minimumInteritemSpacing = margin;    //最小item间距
    
    // 创建UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = collectionView;
    self.collectionView = collectionView;
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.scrollEnabled = NO;
    
    // 注册cell
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    [collectionView registerNib:[UINib nibWithNibName:@"BQSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma mark - 设置导航条
- (void)setupNavBar {
    // 设置右边按钮组
    // 1. 夜间模式
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    // 2. 设置
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] heighImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // 设置titleView
    self.navigationItem.title = @"我的";
}

- (void)night:(UIButton *)button {
    BQFunc();
    button.selected = !button.selected;
}

#pragma mark - 点击设置调用
- (void)setting {
    BQFunc();
    // 跳转到设置页面
    BQSettingViewController *settingVc = [[BQSettingViewController alloc] init];
    settingVc.hidesBottomBarWhenPushed = YES;   // 必须在跳转前设置
    [self.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    // 小盒子的点击事件
    BQLog(@"%@",indexPath);
    // 跳转界面 push 展示网页
    /*
        1.Safari openURL：自带很多功能 （进度条，刷新，前进，倒退..）就是打开了一个浏览器，跳出自己的应用
        2.UIWebView：没有功能，在当前应用中打开网页，自己去实现某些功能，但不能实现进度条功能
        3.SFSafariViewController：iOS9+ 专门用来展示网页 需求：既想要在当前应用展示网页，又想要safari功能
            需要导入#import <SafariServices/SafariServices.h>框架
        4.WKWebView：iOS8+ （UIWebView升级版本）添加功能：1）监听进度条 2）缓存
     */
    BQSquareItem *item = self.squareItems[indexPath.row];
    
    if (![item.url containsString:@"http"]) {
        return;
    }
    
    // 方法一：WKWebView 创建网页控制器
    BQWebViewController *webVc = [[BQWebViewController alloc] init];
    webVc.url = [NSURL URLWithString:item.url];

    [self.navigationController pushViewController:webVc animated:YES];
    
    // 方法二：SFSafariViewController 创建网页控制器
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
//    /*
//        safariVc.delegate = self;
//        self.navigationController.navigationBarHidden = YES;
//        [self.navigationController pushViewController:safariVc animated:YES];
//     */
//    [self presentViewController:safariVc animated:YES completion:nil]; // 推荐使用modal自动处理 而不是push
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {  // 多少个小方块 -> 取决于模型数组的元素数量
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 从缓存池取
    BQSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
}

#pragma mark - SFSafariViewControllerDelegate   // 不用做了 modal自动做好了
//- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {    //点Done回退
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
