//
//  BQSeeBigPictureViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/7.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

/*
 一种很常见的开发思路
 1.在viewDidLoad方法中添加初始化子控件
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 
 另一种常见的开发思路
 1.控件弄成懒加载
 2.在viewDidLayoutSubviews方法中布局子控件（设置子控件的位置和尺寸）
 */

#import "BQSeeBigPictureViewController.h"
#import <FLAnimatedImageView+WebCache.h>
#import <FLAnimatedImageView.h>
#import "BQTopic.h"
#import <SVProgressHUD.h>
#import <Photos/Photos.h>

@interface BQSeeBigPictureViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;  //保存按钮
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) FLAnimatedImageView *imageView;

/** 获得当前App对应的自定义相册 */
- (PHAssetCollection *)createdCollection;
/** 获取刚才保存到【相机胶卷】的图片 */
- (PHFetchResult<PHAsset *> *)createdAssets;
@end

@implementation BQSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.frame = self.view.bounds;
    
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    scrollView.frame = [UIScreen mainScreen].bounds;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)]]; //给scrollView增加回退手势
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    
    // imageView
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            return ;
        }
        self.saveButton.enabled = YES;
    }];
    imageView.bq_width = scrollView.bq_width;
    imageView.bq_height = imageView.bq_width * self.topic.height / self.topic.width;
    imageView.bq_x = 0;
    if (imageView.bq_height > BQScreenH) { //超过屏幕长度 就滚动显示
        imageView.bq_y = 0;
        self.scrollView.contentSize = CGSizeMake(0, imageView.bq_height);
    }else { // 否则居中显示
        imageView.bq_centerY = BQScreenH * 0.5;
    }
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 图片缩放
    CGFloat maxScale = self.topic.width / imageView.bq_width;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
        scrollView.delegate = self;
    }
}


#pragma mark - <UIScrollViewDelegate>
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - 监听点击
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// save点击事件：保存图片至相册胶卷
- (IBAction)save:(id)sender {
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    // 请求/检查访问权限：
    // 如果用户还没有做出选择，会自动弹框，用户对弹框做出选择后，才会调用block
    // 如果之前已经做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BQLog(@"%zd",status);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied && oldStatus != PHAuthorizationStatusNotDetermined) { //用户拒绝当前App访问相册
                BQLog(@"提醒用户打开开关");
                [SVProgressHUD showErrorWithStatus:@"无系统权限访问"];
            } else if (status == PHAuthorizationStatusAuthorized){  // 用户允许当前App访问相册
                [self saveImageIntoAlbum];
            } else if (status == PHAuthorizationStatusRestricted){  // 无法访问相册
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
            }
        });
    }];
}

/**
 保存图片到相册
 */
- (void)saveImageIntoAlbum {
    // 1.获取相机胶卷里的该【相片】
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    if (createdAssets==nil) {
        [SVProgressHUD showErrorWithStatus:@"获取相片失败!"];
        return;
    }
    
    // 2.获得【自定义相册】
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection==nil) {
        [SVProgressHUD showErrorWithStatus:@"创建/获取相册失败!"];
        return;
    }
    
    
    // 3.保存图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];    // 添加刚才保存的图片到【自定义相册】
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    if (error) {    //最后的判断
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

#pragma mark - 获得当前App对应的自定义相册/保存的图片
/**
 获取当前App对应的自定义相册
 */
- (PHAssetCollection *)createdCollection {
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];   // 获得app名
    
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];    //抓取所有的自定义相册
    
    for (PHAssetCollection *collection in collections) {    // 遍历查找当前app对应的自定义相册
        if ([collection.localizedTitle isEqualToString:title]) {    //找到对应的相册：说明已经创建完毕，直接返回
            return collection;
        }
    }
    
    PHAssetCollection *createdCollection = nil;
    if (createdCollection == nil){  //自定义相册没被创建过，需要创建自定义相册
        NSError *error = nil;
        __block NSString *createdCollectionID = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;  // 创建一个自定义相册,并拿到相册的唯一标识
        } error:&error];
        if (error) {    //如果有值，则创建相册失败，直接返回
            return nil;
        }
        
        createdCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;   //拿到唯一标识后，拿到唯一相册
    }
    return createdCollection;
}

/**
 获取保存在相机胶卷的这张图片（通过AssetID）
 */
- (PHFetchResult<PHAsset *> *)createdAssets {
    // 同步执行修改操作
    NSError *error = nil;
    // 保存图片到相机胶卷
    __block NSString *assetID = nil;    //相片ID
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;  // 赋值ID
    } error:&error];
    
    if (error) {
        return nil;
    }
    
    // 返回相机胶卷里的该相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

- (void)dealloc {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 一、保存图片到【自定义相册】
 1.保存图片到【相机胶卷】
 1> C语言函数UIImageWriteToSavedPhotosAlbum
 2> AssetsLibrary框架
 3> Photos框架
 
 2.拥有一个【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 
 3.添加刚才保存的图片到【自定义相册】
 1> AssetsLibrary框架
 2> Photos框架
 
 二、Photos框架须知
 1.PHAsset : 一个PHAsset对象就代表相册中的一张图片或者一个视频
 1> 查 : [PHAsset fetchAssets...]
 2> 增删改 : PHAssetChangeRequest(包括图片\视频相关的所有改动操作)
 
 2.PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
 1> 查 : [PHAssetCollection fetchAssetCollections...]
 2> 增删改 : PHAssetCollectionChangeRequest(包括相册相关的所有改动操作)
 
 3.对相片\相册的任何【增删改】操作，都必须放到以下方法的block中执行
 -[PHPhotoLibrary performChanges:completionHandler:]
 -[PHPhotoLibrary performChangesAndWait:error:]
 */

/*
 Foundation和Core Foundation的数据类型可以互相转换，比如NSString *和CFStringRef
 NSString *string = (__bridge NSString *)kCFBundleNameKey;
 CFStringRef string = (__bridge CFStringRef)@"test";
 
 获得相机胶卷相册
 [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil]
 */

/*
 错误信息：This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]
 // 异步执行修改操作
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
 [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
 } completionHandler:^(BOOL success, NSError * _Nullable error) {
 if (error) {
 [SVProgressHUD showErrorWithStatus:@"保存失败！"];
 } else {
 [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
 }
 }];
 
 // 同步执行修改操作
 NSError *error = nil;
 [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
 [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
 } error:&error];
 if (error) {
 [SVProgressHUD showErrorWithStatus:@"保存失败！"];
 } else {
 [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
 }
 
 */

@end
