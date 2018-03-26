//
//  BQEssenceViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/14.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQEssenceViewController.h"
#import <Masonry/Masonry.h>
#import "BQTitleButton.h"

#import "BQAllViewController.h"
#import "BQVideoViewController.h"
#import "BQVoiceViewController.h"
#import "BQPictureViewController.h"
#import "BQWordViewController.h"

/*
    名字叫做attribues并且是NSDictionary * 类型的参数，它的key一般都有以下规律
    1> 所有key来源于：NSAttributedString.h
    2> 格式基本都是：NS*******AttributeName
 */


@interface BQEssenceViewController () <UIScrollViewDelegate>
/** 标题栏 */
@property (nonatomic,weak) UIView *titlesView;
/** 标题下划线 */
@property (nonatomic,weak) UIView *titleUnderLine;
/** 上一次点击的标题按钮 */
@property (nonatomic,weak) BQTitleButton *previousClickedTitleButton;
/** ScrollView */
@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation BQEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // 初始化子控制器
    [self setupChildVCs];
    
    // 设置导航条
    [self setupNavBar];
    
    // 设置scrollView
    [self setupScrollView];
    
    // 设置标签栏
    [self setupTitlesView];
    
    // 懒加载childVcView
    [self addChildVcViewIntoScrollView:0];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_titlesView mas_makeConstraints:^(MASConstraintMaker *make) {//添加titleView的约束
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
        make.height.equalTo(BQTitlesViewH);
    }];
}

#pragma mark - 设置子控制器
- (void)setupChildVCs {
    [self addChildViewController:[[BQAllViewController alloc] init]];
    [self addChildViewController:[[BQVideoViewController alloc] init]];
    [self addChildViewController:[[BQVoiceViewController alloc] init]];
    [self addChildViewController:[[BQPictureViewController alloc] init]];
    [self addChildViewController:[[BQWordViewController alloc] init]];
}

// 懒加载子控制器的View到scrollView
// 方法1：传索引(这个好，可扩展性强，而且可以加载任意控制器)
- (void)addChildVcViewIntoScrollView:(NSInteger)index {
    // 1.拿到第index个控制器的view
    UIView *childVcView = self.childViewControllers[index].view;
    if (childVcView.superview) {return;} //有值就直接返回，避免加载多次
    // 2.设置这个view在scrollView上的frame
    childVcView.frame = self.scrollView.bounds; //childView的frame就是scrollview的bounds
    // 3.添加这个view倒scrollView
    [self.scrollView addSubview:childVcView];
}

// 方法2：不传参数（只能加载当前的控制器,有局限性）
- (void)addChildVcViewIntoScrollView{
    // 1.通过计算拿到index
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.bq_width;
    // 2.拿到第index个控制器的view
    UIView *childVcView = self.childViewControllers[index].view;
    if (childVcView.superview) {return;} //有值就直接返回，避免加载多次
    // 3.设置这个view在scrollView上的frame
    childVcView.frame = self.scrollView.bounds; //childView的frame就是scrollview的bounds
    
    /*
    //  推导过程：
    //    childVcView.frame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, scrollViewW, self.scrollView.xmg_height);
    
    //    childVcView.frame = CGRectMake(self.scrollView.contentOffset.x, 0, scrollViewW, self.scrollView.xmg_height);
    
    //    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.xmg_height);
     */

    // 4.添加这个view倒scrollView
    [self.scrollView addSubview:childVcView];
}


#pragma mark - 设置导航条
- (void)setupNavBar{
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] heighImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    // 设置右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] heighImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:nil];
    // 设置titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}

- (void)game {
    BQFunc();
}


#pragma mark - 设置scrollView
// 设置scrollView
- (void)setupScrollView {
    // 不允许自动修改ScrollView的内边距
//    self.automaticallyAdjustsScrollViewInsets = NO;  // 已过期
    
    /*
     typedef NS_ENUM(NSInteger, UIScrollViewContentInsetAdjustmentBehavior) {
     UIScrollViewContentInsetAdjustmentAutomatic, // Similar to .scrollableAxes, but for backward compatibility will also adjust the top & bottom contentInset when the scroll view is owned by a view controller with automaticallyAdjustsScrollViewInsets = YES inside a navigation controller, regardless of whether the scroll view is scrollable
     UIScrollViewContentInsetAdjustmentScrollableAxes, // Edges for scrollable axes are adjusted (i.e., contentSize.width/height > frame.size.width/height or alwaysBounceHorizontal/Vertical = YES)
     UIScrollViewContentInsetAdjustmentNever, // contentInset is not adjusted
     UIScrollViewContentInsetAdjustmentAlways, // contentInset is always adjusted by the scroll view's safeAreaInsets
     } API_AVAILABLE(ios(11.0),tvos(11.0));
     */
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    // 不允许自动修改ScrollView的内边距
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsVerticalScrollIndicator = NO; // 禁用垂直滚动条
    scrollView.showsHorizontalScrollIndicator = NO; // 禁用水平滚动条
    scrollView.pagingEnabled = YES; // 开启分页功能
    scrollView.scrollsToTop = NO;   // 点击状态栏，这个scrollView不会回到最顶部
    scrollView.delegate = self;
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    /*
    for (NSInteger i = 0; i < 5; i++) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.bq_width = scrollView.bq_width;
        tableView.bq_height = scrollView.bq_height;
        tableView.bq_y = 0;
        tableView.bq_x = i * scrollView.bq_width;
        tableView.backgroundColor = BQRandomColor;
        [scrollView addSubview:tableView];
    }
     */
    
    NSInteger count = self.childViewControllers.count;  //子控制器的个数
    CGFloat scrollViewW = scrollView.bq_width;
//    CGFloat scrollViewH = scrollView.bq_height;
//
//    for (NSInteger i = 0; i < count; i++) {
//        //取出i位置自控制器的view
//        UIView *childVcView = self.childViewControllers[i].view;    // 提前创建好所有控制器，性能不好..
//        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
//        [scrollView addSubview:childVcView];
//    }
    
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}



#pragma mark - 设置标签栏
// 设置标签栏
- (void)setupTitlesView {
    UIView *titlesView = [[UIView alloc] init];
    // 设置半透明背景色
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    //    titlesView.alpha = 0.5;   //父控件的透明度会作用到所有子控件的透明度
    titlesView.frame = CGRectMake(0, BQNavMaxY , self.view.bq_width, BQTitlesViewH);
    
    _titlesView = titlesView;
    [self.view addSubview:titlesView];
    
    // 设置标题栏按钮
    [self setupTitleButtons];
    // 设置标题下划线
    [self setupTitleUnderLine];
}

// 设置标题栏按钮
- (void)setupTitleButtons {
    // 标题文字
    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    // 标题按钮的尺寸
    CGFloat titleButtonW = self.titlesView.bq_width / titles.count;
    CGFloat titleButtonH = self.titlesView.bq_height;
    
    // 创建5个标题
    for (NSInteger i = 0; i < titles.count; i++) {
        BQTitleButton *titleButton = [[BQTitleButton alloc] init];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.tag = i;
        [self.titlesView addSubview:titleButton];
        
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
        
//        titleButton.backgroundColor = BQRandomColor;
        // 设置文字
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}

// 设置标题下划线
- (void)setupTitleUnderLine {
    // 标题按钮
    BQTitleButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderLine = [[UIView alloc] init];
    _titleUnderLine = titleUnderLine;
    titleUnderLine.bq_height = 2;
    titleUnderLine.bq_y = self.titlesView.bq_height - titleUnderLine.bq_height;
    titleUnderLine.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titlesView addSubview:titleUnderLine];
    
    // 切换按钮的状态
    firstTitleButton.selected = YES;
    self.previousClickedTitleButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit];
    self.titleUnderLine.bq_width = firstTitleButton.titleLabel.bq_width + 10;
    self.titleUnderLine.bq_centerX = firstTitleButton.bq_centerX;
}

// 标题按钮的点击事件
- (IBAction)titleButtonClick:(BQTitleButton *)titleButton {
    // 重复点击了标题按钮
    if (self.previousClickedTitleButton == titleButton) {
        BQLog(@"%@ -- reload Data from titleBtnRepeatClick",self.class);
        // 发布titleClick通知
        [[NSNotificationCenter defaultCenter] postNotificationName:BQTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 处理标题按钮点击
    [self dealWithTitleButtonClick:titleButton];
}

// 处理标题按钮点击
- (void)dealWithTitleButtonClick:(BQTitleButton *)titleButton{
    // 切换按钮的状态
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.previousClickedTitleButton = titleButton;
    
    NSInteger index = titleButton.tag;  //第几个控制器
    
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleUnderLine.bq_width = titleButton.titleLabel.bq_width + 10;
        self.titleUnderLine.bq_centerX = titleButton.bq_centerX;
        
        // 滚动scrollView到标题按钮对应的子控制器 : contentOffset.x = 内容的最左边 - frame的最左边
        //        NSInteger index = [self.view.subviews indexOfObject:titleButton]; // 遍历，性能弱
        CGFloat offsetX = self.scrollView.bq_width * index;
        self.scrollView.contentOffset = CGPointMake(offsetX,self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 懒加载添加子控制器的View:性能优化
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 功能：点击状态栏返回到对应子控制器scrollView顶部
    // 设置index位置对应的tableView.scrollsToTop = YES,其他的为NO
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        UIViewController *childVc = self.childViewControllers[i];
        // 如果view还没有被创建，就不用去处理
        if (!childVc.isViewLoaded) {continue;}  // 第一层判断
        
        UIScrollView *scrollView = (UIScrollView *)childVc.view;
        if (![scrollView isKindOfClass:[UIScrollView class]]) {continue;}   //第二层判断
        
        //        if (i == index) {   //本标题按钮对应的子控制器
        //            scrollView.scrollsToTop = YES;
        //        }else {
        //            scrollView.scrollsToTop = NO;
        //        }
        scrollView.scrollsToTop = (i == index);
    }
}

#pragma mark - UIScrollViewDelegate
/**
 *   ScrollView结束拖拽的时候调用
 *   @param scrollView 当前ScrollView
 *   @param decelerate 参数？
 *
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    BQFunc();
}
 */

/**
 *   ScrollView结束滑动的时候调用（速度为0）
 *   @param scrollView 当前ScrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{ //速度减为0
    BQFunc();
    // 先求出按钮的索引：偏移量/宽度 = index
    NSInteger index = scrollView.contentOffset.x / scrollView.bq_width;
    // 再点击对应的标题按钮
    BQTitleButton *titleButton = self.titlesView.subviews[index];
//    BQTitleButton *titleButton = [self.titlesView viewWithTag:index];//会报错，每个控件的tag默认为0
    [self dealWithTitleButtonClick:titleButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
