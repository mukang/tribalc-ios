//
//  WXMediaMessage+Category.m
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "WXMediaMessage+Category.h"

@implementation WXMediaMessage (Category)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         description:(NSString *)description
                         mediaObject:(id)mediaObject
                          messageExt:(NSString *)messageExt
                       messageAction:(NSString *)action
                          thumbImage:(UIImage *)thumbImage
                             tagName:(NSString *)tagName {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}

@end
