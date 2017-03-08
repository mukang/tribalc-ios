//
//  WXMediaMessage+Category.h
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "WXApiObject.h"

@interface WXMediaMessage (Category)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         description:(NSString *)description
                         mediaObject:(id)mediaObject
                          messageExt:(NSString *)messageExt
                       messageAction:(NSString *)action
                          thumbImage:(UIImage *)thumbImage
                            tagName:(NSString *)tagName;

@end
