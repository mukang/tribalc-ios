//
//  WXApiRequestHandler.h
//  individual
//
//  Created by 穆康 on 2017/3/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"

@interface WXApiRequestHandler : NSObject

+ (BOOL)sendImageData:(NSData *)imageData
              tagName:(NSString *)tagName
           messageExt:(NSString *)messageExt
               action:(NSString *)action
           thumbImage:(UIImage *)thumbImage
              inScene:(enum WXScene)scene;

@end
