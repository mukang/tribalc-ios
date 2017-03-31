//
//  TCRepairsDetailViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCPropertyRepairsType) {
    TCPropertyRepairsTypePipe = 0,    // 管件维修
    TCPropertyRepairsTypeLighting,    // 公共照明
    TCPropertyRepairsTypeWaterPipe,   // 水管维修
    TCPropertyRepairsTypeElectric,    // 电器维修
    TCPropertyRepairsTypeOther        // 其他
};

@interface TCRepairsDetailViewController : TCBaseViewController

@property (nonatomic, readonly) TCPropertyRepairsType repairsType;

/**
 指定初始化方法

 @param repairsType 维修类型
 @return TCRepairsDetailViewController对象
 */
- (instancetype)initWithPropertyRepairsType:(TCPropertyRepairsType)repairsType;

@end
