//
//  TCWebViewController.h
//  individual
//
//  Created by 穆康 on 2017/5/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@interface TCWebViewController : TCBaseViewController

@property (nonatomic, readonly) UIWebView * webView;
@property (nonatomic) NSURL * url;
@property (nonatomic, assign) BOOL showControls;

@end
