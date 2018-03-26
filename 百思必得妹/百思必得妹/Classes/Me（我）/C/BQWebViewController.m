//
//  BQWebViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/2/4.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQWebViewController.h"
#import <WebKit/WebKit.h>
@interface BQWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) WKWebView *webView;
@end

@implementation BQWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加WebView
    WKWebView *webView = [[WKWebView alloc] init];
    _webView = webView;
    [self.contentView addSubview:webView];
    
    // 加载网页
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    
    // KVO监听属性改变
    /*
     KVO使用:
        addObserver：观察者
        forKeyPath：观察webview哪个属性
        options：NSKeyValueObservingOptionNew观察新值改变
     注意点：对象销毁前 一定要记得移除 -dealloc
     */
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    
    // 进度条
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    _webView.frame = self.contentView.bounds;
}

#pragma mark - KVO
// 只要观察者有新值改变就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.backItem.enabled = self.webView.canGoBack;
    self.forwardItem.enabled = self.webView.canGoForward;
    self.title = self.webView.title;
    self.progressView.progress = self.webView.estimatedProgress;
    self.progressView.hidden = self.webView.estimatedProgress>=1;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"canGoForward"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - 按钮的点击事件
- (IBAction)goBack:(id)sender { // 回退
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {  // 前进
    [self.webView goForward];
}

- (IBAction)reload:(id)sender { //刷新
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
