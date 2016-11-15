//
//  TCBioEditViewController.h
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TCBioEditType) {
    TCBioEditTypeNick,
    TCBioEditTypeGender,
    TCBioEditTypeBirthdate,
    TCBioEditTypeAffection,
    
};

typedef void(^TCBioEditBlock)(BOOL isEdit, TCBioEditType bioEditType);

@interface TCBioEditViewController : UIViewController

@property (nonatomic) TCBioEditType bioEditType;


/** 简介编辑回调 */
@property (copy, nonatomic) TCBioEditBlock bioEditBlock;

@end
