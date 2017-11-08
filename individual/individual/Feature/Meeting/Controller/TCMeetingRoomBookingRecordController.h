//
//  TCMeetingRoomBookingRecordController.h
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCMeetingRoomBookingRecordControllerType) {
    TCMeetingRoomContactsViewControllerTypeIndividual = 0,      // 个人
    TCMeetingRoomContactsViewControllerTypeCompany          // 公司
};

@interface TCMeetingRoomBookingRecordController : TCBaseViewController

@property (nonatomic) BOOL isFromMeetingRoomVC;

- (instancetype)initWithMeetingRoomBookingRecordType:(TCMeetingRoomBookingRecordControllerType)type companyId:(NSString *)companyId;

@end
