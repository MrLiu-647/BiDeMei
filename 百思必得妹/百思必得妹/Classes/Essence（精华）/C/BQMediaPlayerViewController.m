//
//  BQMediaPlayerViewController.m
//  百思必得妹
//
//  Created by 刘思齐 on 2018/3/18.
//  Copyright © 2018年 刘思齐. All rights reserved.
//

#import "BQMediaPlayerViewController.h"

@interface BQMediaPlayerViewController()

@property (nonatomic, strong) NSString *URLString;

@end

@implementation BQMediaPlayerViewController

- (instancetype)initWithURLString:(NSString *)URLString
{
    if (self = [super init]) {
        self.URLString = URLString;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:self.URLString]];
    [self.player play];
}

- (void)dealloc {
    [self.player cancelPendingPrerolls];
//    [self.player replaceCurrentItemWithPlayerItem:nil];
//    self.player = nil;
}

@end
