//
//  BQSettingViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/1/18.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQSettingViewController.h"
#import "BQFileTool.h"
#import <SVProgressHUD/SVProgressHUD.h> // 使用方便

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface BQSettingViewController ()

@property (nonatomic,assign) NSInteger totalSize;

@end

@implementation BQSettingViewController

static NSString * const ID = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    // 设置右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:0 target:self action:@selector(jump)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    // SVProgressHUD的使用
    [SVProgressHUD showWithStatus:@"正在计算缓存大小..."];
    
    [BQFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        
        _totalSize = totalSize;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
    }];
}

- (void)jump {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 计算缓存数据 => 计算整个应用的缓存数据 => 沙盒（Cashe） => 获取Cashe文件夹的大小
    // SDWebImage：帮助我们做了缓存
    
    // 获取缓存尺寸的字符串
    cell.textLabel.text = [self sizeStr];
    
    return cell;
}

// 点击cell就会调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 清空缓存
    [BQFileTool removeDirectoryAtPath:CachePath];
    _totalSize = 0;
    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD setStatus:@"正在清除缓存.."];
        });
        sleep(1);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [SVProgressHUD showSuccessWithStatus:@"清除成功！"];
        });
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    });
}

- (void)modeSwitchingExample {
    
}


- (void)dealloc {
    [SVProgressHUD dismiss];
}
/*
    业务类：以后开发中用来专门处理某些事件，网络处理，缓存处理
 */

#pragma mark - 缓存Cache的方法


// 获得缓存大小的字符串
- (NSString *)sizeStr {
    NSString *sizeStr = @"清除缓存";
    if (_totalSize > 1000 * 1000) {
        //MB
        CGFloat sizeF = _totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(共%.2fMB)",sizeStr,sizeF];
    }else if (_totalSize > 1000) {
        //KB
        CGFloat sizeF = _totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(共%.2fKB)",sizeStr,sizeF];
    }else if (_totalSize > 0){
        // B
        sizeStr = [NSString stringWithFormat:@"%@(共%ldfB)",sizeStr,_totalSize];
    }
    return sizeStr;
}

/*
// 清空缓存
- (void)clearCache {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 获取cache文件夹下所有文件,不包括子路径的子文件
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:CachePath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完整的全路径
        NSString *filePath = [CachePath stringByAppendingPathComponent:subPath];
        
        // 删除文件
        [mgr removeItemAtPath:filePath error:nil];
    }
}
 
// 计算缓存的大小
- (NSInteger)getFileSize:(NSString *)directoryPath {
    // NSFileManager：
    // attributesOfItemAtPath:指定文件路径就能获取文件属性 不是文件夹
    // 遍历文件夹中所有文件，再一个一个加起来

    // 1.获取文件的管理者
    NSFileManager *mgr = [NSFileManager defaultManager];

    // 2.获取文件夹下所有的子路径 （包括子路径的子文件）
    NSArray *subPaths = [mgr subpathsAtPath:directoryPath];

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
    return totalSize;
}
*/


@end
