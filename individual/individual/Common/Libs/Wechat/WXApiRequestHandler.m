//
//  WXApiRequestHandler.m
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "WXApiRequestHandler.h"
#import "WXApi.h"
#import "WXMediaMessage+Category.h"
#import "SendMessageToWXReq+Category.h"

@implementation WXApiRequestHandler

+ (BOOL)sendImageData:(NSData *)imageData
              tagName:(NSString *)tagName
           messageExt:(NSString *)messageExt
               action:(NSString *)action
           thumbImage:(UIImage *)thumbImage
              inScene:(enum WXScene)scene {
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   description:nil
                                                   mediaObject:imageObject
                                                    messageExt:messageExt
                                                 messageAction:action
                                                    thumbImage:thumbImage
                                                       tagName:tagName];
    
    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:nil
                                                   orMediaMessage:message
                                                            bText:NO
                                                          inScene:scene];
    
    return [WXApi sendReq:req];
}

@end
