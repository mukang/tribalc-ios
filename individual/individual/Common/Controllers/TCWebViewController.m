//
//  TCWebViewController.m
//  individual
//
//  Created by 穆康 on 2017/5/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWebViewController.h"
#import <TCCommonLibs/TCRefreshHeader.h>

@interface TCWebViewController () <UIWebViewDelegate>

@end

@implementation TCWebViewController {
    UIBarButtonItem *_closeItem;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _showControls = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = TCBackgroundColor;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                  style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(handleClickCloseItem:)];
    
    if (_url) {
        [self loadURL:_url];
    }
    
}

#pragma mark - Private Methods

- (void)loadURL:(NSURL *)url {
    if (url) {
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.navigationItem.title = @"正在加载...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    if (self.showControls) {
        if ([_webView canGoBack]) {
            [_webView goBack];
            UIBarButtonItem *backItem = self.navigationItem.leftBarButtonItem;
            [self.navigationItem setLeftBarButtonItems:@[backItem, _closeItem]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleClickCloseItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
