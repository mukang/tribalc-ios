//
//  TCModelImport.h
//  individual
//
//  Created by 穆康 on 2016/11/9.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/********** 用户相关 **********/
#import "TCUserSession.h"
#import "TCUserInfo.h"
#import "TCUserSipInfo.h"
#import "TCUserPhoneInfo.h"
#import "TCUserAddress.h"
#import "TCUserShippingAddress.h"
#import "TCWalletAccount.h"
#import "TCWalletBill.h"
#import "TCWalletBillWrapper.h"
#import "TCBankCard.h"
#import "TCUserCompanyInfo.h"
#import "TCUserIDAuthInfo.h"
#import "TCUserPayment.h"
#import "TCCreditBillWrapper.h"

/********** 商品相关 **********/
#import "TCGoodsWrapper.h"
#import "TCGoods.h"
#import "TCGoodsDetail.h"
#import "TCGoodsStandard.h"

#import "TCStoreInfo.h"
#import "TCStoreDetailInfo.h"

/********** 服务相关 **********/
#import "TCServiceWrapper.h"
#import "TCService.h"
#import "TCServiceDetail.h"
#import "TCMarkStore.h"
#import "TCListStore.h"
#import "TCDetailStore.h"
#import "TCStoreWrapper.h"

/********** 订单相关 **********/
#import "TCOrderWrapper.h"
#import "TCOrderItem.h"
#import "TCOrder.h"
#import "TCOrderCreateItem.h"

/********** 预订相关 **********/
#import "TCReservationWrapper.h"
#import "TCReservation.h"
#import "TCReservationDetail.h"

/********** 购物车相关 **********/
#import "TCShoppingCartWrapper.h"
#import "TCListShoppingCart.h"
#import "TCCartItem.h"

/********** OSS上传相关 **********/
#import "TCUploadInfo.h"

/********** 社区相关 **********/
#import "TCCommunity.h"
#import "TCCommunityDetailInfo.h"
#import "TCCommunityListInCity.h"
#import "TCCommunityReservationInfo.h"

/********** 公司相关 **********/
#import "TCCompanyInfo.h"

/********** 物业报修 **********/
#import "TCPropertyManageWrapper.h"
#import "TCPropertyManage.h"
#import "TCPropertyRepairsInfo.h"

/*********** 门锁 ***********/
#import "TCLockKey.h"
#import "TCLockEquip.h"
#import "TCLockWrapper.h"
#import "TCVisitorInfo.h"
#import "TCMultiLockKey.h"

/*********** 支付相关 ***********/
#import "TCBFPayInfo.h"
#import "TCBFSessionInfo.h"
#import "TCPaymentRequestInfo.h"
#import "TCCreditBill.h"
#import "TCWechatPaymentInfo.h"
#import "TCWechatPaymentRequestInfo.h"

/*********** 系统初始化相关 ***********/
#import "TCAppVersion.h"
#import "TCPromotions.h"
#import "TCFeatureSwitches.h"
#import "TCAppInitializationInfo.h"
#import "TCMainPage.h"

/*********** 线上活动相关 ***********/
#import "TCSigninRecordDay.h"
#import "TCSigninRecordMonth.h"
#import "TCActivityInfo.h"

/*********** 租赁相关 ***********/
#import "TCRentProtocol.h"
#import "TCRentPlanItem.h"
#import "TCRentProtocolWithholdInfo.h"

/*********** 消息服务 ***********/
#import "TCHomeMessageWrapper.h"
#import "TCMessageManagementWrapper.h"

/*********** 会议室预定 ***********/
#import "TCBookingDate.h"
#import "TCMeetingRoomConditions.h"


@interface TCModelImport : NSObject

@end
