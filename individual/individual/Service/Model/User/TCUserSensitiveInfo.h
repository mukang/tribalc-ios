//
//  TCUserSensitiveInfo.h
//  individual
//
//  Created by 穆康 on 2016/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUserSensitiveInfo : NSObject

/** 用户ID */
@property (copy, nonatomic) NSString *ID;
/** 手机号码 */
@property (copy, nonatomic) NSString *phone;
/** 身份证号码 */
@property (copy, nonatomic) NSString *idNo;
/** 默认地址ID */
@property (copy, nonatomic) NSString *addressID;

@end
