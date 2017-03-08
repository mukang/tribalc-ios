//
//  SendMessageToWXReq+Category.h
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "WXApiObject.h"

@interface SendMessageToWXReq (Category)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         orMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                inScene:(enum WXScene)scene;

@end
