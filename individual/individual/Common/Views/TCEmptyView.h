//
//  TCEmptyView.h
//  individual
//
//  Created by 王帅锋 on 2017/12/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCEmptyType) {
    TCEmptyTypeNoRepairRecord = 0,           // 无报修记录
    TCEmptyTypeNoSearchResult,               // 无搜索记录
    TCEmptyTypeNoCertify,                    // 无身份认证
    TCEmptyTypeNoBindCompany,                // 无绑定公司
    TCEmptyTypeNoMeetingRoom,                // 无会议室
    TCEmptyTypeNoMaintainRecord,             // 无物业维修记录
    TCEmptyTypeNoBillResult,                 // 无对账单
    TCEmptyTypeNoBankCardResult,             // 无银行卡
    TCEmptyTypeNoHistoryBillRecord           // 无历史账单
};

@protocol TCEmptyViewDelegate<NSObject>

- (void)emptyViewBtnDidClick;

@end

@interface TCEmptyView : UIView

@property (assign, nonatomic) TCEmptyType type;

@property (copy, nonatomic) NSString *des;

@property (weak, nonatomic) id<TCEmptyViewDelegate> delegate;

@end
