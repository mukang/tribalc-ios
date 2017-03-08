//
//  SendMessageToWXReq+Category.m
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "SendMessageToWXReq+Category.h"

@implementation SendMessageToWXReq (Category)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         orMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                inScene:(enum WXScene)scene {
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end
