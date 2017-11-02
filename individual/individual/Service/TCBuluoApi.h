//
//  TCBuluoApi.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCModelImport.h"
#import "TCEnum.h"

extern NSString *const TCBuluoApiNotificationUserDidLogin;
extern NSString *const TCBuluoApiNotificationUserDidLogout;
extern NSString *const TCBuluoApiNotificationUserInfoDidUpdate;
extern NSString *const TCBuluoApiNotificationUserAuthDidUpdate;

typedef NS_ENUM(NSInteger, TCPayPurpose) { // 付款目的
    TCPayPurposeOrder = 0,   // 订单
    TCPayPurposeMaintain,    // 维修
    TCPayPurposeFace2Face,   // 面对面付款
    TCPayPurposeRent,        // 租金
    TCPayPurposeCredit       // 信用账单还款
};


/**
 宝付支付结果
 */
typedef NS_ENUM(NSInteger, TCBFPayResult) {
    TCBFPayResultError = 0,  // 错误
    TCBFPayResultSucceed,    // 成功
    TCBFPayResultFailure,    // 失败
    TCBFPayResultProcessing, // 处理中
    TCBFPayResultNotPay      // 未支付
};

typedef NS_ENUM(NSInteger, TCBFSupportedBankType) {
    TCBFSupportedBankTypeWithhold = 0 // 代付
};

typedef NS_ENUM(NSInteger, TCDataListPullType) {
    TCDataListPullFirstTime = 0,  // 首次拉去数据
    TCDataListPullOlderList,      // 拉取老数据
    TCDataListPullNewerList       // 拉取更数据
};

typedef NS_ENUM(NSInteger, TCUploadImageType) { // 上传图像类型
    TCUploadImageTypeNormal = 0,  // 常规的
    TCUploadImageTypeSpecial      // 特殊的（例如：头像和背景图）
};

@interface TCBuluoApi : NSObject

/**
 获取api实例
 
 @return 返回TCBuluoApi实例
 */
+ (instancetype)api;

#pragma mark - 设备相关

@property (nonatomic, assign, readonly, getter=isPrepared) BOOL prepared;

/**
 准备工作

 @param completion 准备完成回调
 */
- (void)prepareForWorking:(void(^)(NSError * error))completion;

#pragma mark - 用户会话相关

/**
 检查是否需要重新登录

 @return 返回BOOL类型的值，YES表示需要，NO表示不需要
 */
- (BOOL)needLogin;

/**
 获取当前已登录用户的会话

 @return 返回currentUserSession实例，返回nil表示当前没有保留的已登录会话或会话已过期
 */
- (TCUserSession *)currentUserSession;

#pragma mark - 普通用户资源

/**
 用户登录，登录后会保留登录状态

 @param phoneInfo 用户登录信息，TCUserPhoneInfo对象
 @param resultBlock 结果回调，userSession为nil时表示登录失败，失败原因见error的code和userInfo
 */
- (void)login:(TCUserPhoneInfo *)phoneInfo result:(void (^)(TCUserSession *userSession, NSError *error))resultBlock;

/**
 用户注销，会检查登录状态，已登录的会撤销登录状态，未登录的情况下直接返回成功

 @param resultBlock 结果回调，success为NO时表示登出失败，失败原因见error的code和userInfo
 */
- (void)logout:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取用户基本信息

 @param userID 用户ID
 @param resultBlock 结果回调，userInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserInfoWithUserID:(NSString *)userID result:(void (^)(TCUserInfo *userInfo, NSError *error))resultBlock;

/**
 修改用户昵称
 
 @param nickname 要改为的昵称
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserNickname:(NSString *)nickname result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户头像

 @param avatar 用户头像地址
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserAvatar:(NSString *)avatar result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户背景图

 @param cover 用户背景图地址
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserCover:(NSString *)cover result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户性别

 @param gender 性别枚举值（只能传入TCUserGenderMale和TCUserGenderFemale）
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserGender:(TCUserGender)gender result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户出生日期

 @param birthdate 出生日期
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserBirthdate:(NSDate *)birthdate result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户情感状况

 @param emotionState 情感状况枚举值（不能传入TCUserEmotionStateUnknown）
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserEmotionState:(TCUserEmotionState)emotionState result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户常用地址

 @param userAddress 常用地址，TCUserAddress对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserAddress:(TCUserAddress *)userAddress result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户坐标

 @param coordinate 用户坐标，[经度, 维度]
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserCoordinate:(NSArray *)coordinate result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户手机

 @param phoneInfo TCUserPhoneInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserPhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户默认收货地址

 @param shippingAddress 收货地址
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)setUserDefaultShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 添加用户收货地址

 @param shippingAddress 用户收货地址，TCUserShippingAddress对象
 @param resultBlock 结果回调，success为NO时表示添加失败，失败原因见error的code和userInfo
 */
- (void)addUserShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL success, TCUserShippingAddress *shippingAddress, NSError *error))resultBlock;

/**
 获取用户收货地址列表

 @param resultBlock 结果回调，addressList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserShippingAddressList:(void (^)(NSArray *addressList, NSError *error))resultBlock;

/**
 获取用户单个收货地址

 @param shippingAddressID 收货地址ID
 @param resultBlock 结果回调，chippingAddress为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserShippingAddress:(NSString *)shippingAddressID result:(void (^)(TCUserShippingAddress *shippingAddress, NSError *error))resultBlock;

/**
 修改用户收货地址

 @param shippingAddress TCUserShippingAddress对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 删除用户收货地址

 @param shippingAddressID 收货地址ID
 @param resultBlock 结果回调，success为NO时表示删除失败，失败原因见error的code和userInfo
 */
- (void)deleteUserShippingAddress:(NSString *)shippingAddressID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 查询公司绑定请求状态
 
 @param resultBlock 结果回调，userCompanyInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchCompanyBlindStatus:(void (^)(TCUserCompanyInfo *userCompanyInfo, NSError *error))resultBlock;

/**
 用户绑定公司
 
 @param userCompanyInfo TCUserCompanyInfo对象
 @param resultBlock 结果回调，success为NO时表示绑定失败，失败原因见error的code和userInfo
 */
- (void)bindCompanyWithUserCompanyInfo:(TCUserCompanyInfo *)userCompanyInfo result:(void (^)(TCUserInfo *userInfo, NSError *error))resultBlock;

/**
 认证用户身份
 
 @param userIDAuthInfo TCUserIDAuthInfo对象
 @param resultBlock 结果回调，认证状态请查看userInfo中的authorizedStatus字段，userInfo为nil时表示请求失败，原因见error的code和userInfo
 */
- (void)authorizeUserIdentity:(TCUserIDAuthInfo *)userIDAuthInfo result:(void (^)(TCUserInfo *userInfo, NSError *error))resultBlock;

/**
 社区参观预约
 
 @param communityReservationInfo TCCommunityReservationInfo对象
 @param resultBlock 结果回调，success为NO时表示预约失败，失败原因见error的code和userInfo
 */
- (void)reserveCommunity:(TCCommunityReservationInfo *)communityReservationInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取用户信息，并处理信息
  */
- (void)fetchCurrentUserInfo;


#pragma mark - 钱包资源

/**
 获取用户钱包信息

 @param resultBlock 结果回调，walletAccount为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchWalletAccountInfo:(void (^)(TCWalletAccount *walletAccount, NSError *error))resultBlock;

/**
 获取企业钱包信息

 @param companyID 企业id
 @param resultBlock 结果回调
 */
- (void)fetchCompanyWalletAccountInfoByCompanyID:(NSString *)companyID result:(void (^)(TCWalletAccount *walletAccount, NSError *error))resultBlock;

/**
 获取用户钱包明细详情

 @param billID 账单id
 @param resultBlock 结果回调，walletBill为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchWalletBillByBillID:(NSString *)billID result:(void (^)(TCWalletBill *walletBill, NSError *error))resultBlock;

/**
 获取用户钱包明细
 
 @param tradingType 交易类型，传nil表示获取全部类型的账单
 @param count  获取数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCWalletBillWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，walletBillWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchWalletBillWrapperByWalletID:(NSString *)walletID tradingType:(NSString *)tradingType count:(NSUInteger)count sortSkip:(NSString *)sortSkip result:(void (^)(TCWalletBillWrapper *walletBillWrapper, NSError *error))resultBlock;

/**
 修改钱包支付密码（首次设置：messageCode和anOldPassword传nil，重置密码：messageCode传nil，找回密码：anOldPassword传nil）

 @param messageCode 短信验证码，找回密码时使用
 @param anOldPassword 旧密码，重置密码时使用
 @param aNewPassword 新密码
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeWalletPasswordByWalletID:(NSString *)walletID messageCode:(NSString *)messageCode anOldPassword:(NSString *)anOldPassword aNewPassword:(NSString *)aNewPassword result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取银行卡列表

 @param resultBlock 结果回调，bankCardList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchBankCardList:(void (^)(NSArray *bankCardList, NSError *error))resultBlock;

/**
 获取准备绑定的银行卡列表
 
 @param resultBlock 结果回调，bankCardList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchReadyToBindBankCardList:(void (^)(NSArray *bankCardList, NSError *error))resultBlock;

/**
 准备添加银行卡信息

 @param bankCard 银行卡信息
 @param resultBlock 结果回调，bankCard为nil时表示添加失败，失败原因见error的code和userInfo
 */
- (void)prepareAddBankCard:(TCBankCard *)bankCard walletID:(NSString *)walletID result:(void (^)(TCBankCard *card, NSError *error))resultBlock;

/**
 确认添加银行卡信息

 @param bankCardID 银行卡ID
 @param verificationCode 验证码
 @param resultBlock 结果回调，success为NO时表示添加失败，失败原因见error的code和userInfo
 */
- (void)confirmAddBankCardWithID:(NSString *)bankCardID verificationCode:(NSString *)verificationCode walletID:(NSString *)walletID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 删除银行卡

 @param bankCardID 银行卡ID
 @param resultBlock 结果回调，success为NO时表示删除失败，失败原因见error的code和userInfo
 */
- (void)deleteBankCard:(NSString *)bankCardID walletID:(NSString *)walletID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 提交付款申请

 @param paymentRequestInfo 付款申请信息
 @param payPurpose 付款目的
 @param resultBlock 结果回调
 */
- (void)commitPaymentRequest:(TCPaymentRequestInfo *)paymentRequestInfo payPurpose:(TCPayPurpose)payPurpose walletID:(NSString *)walletID result:(void (^)(TCUserPayment *userPayment, NSError *error))resultBlock;

/**
 查询付款申请

 @param paymentID 付款ID
 @param resultBlock 结果回调，userPayment为nil时表示查询失败，失败原因见error的code和userInfo
 */
- (void)fetchUserPaymentByWalletID:(NSString *)walletID paymentID:(NSString *)paymentID result:(void (^)(TCUserPayment *userPayment, NSError *error))resultBlock;

/**
 提交银行卡提现请求
 
 @param amount 总计金额
 @param bankCardID 银行卡id
 @param resultBlock 结果回调，success为NO时表示提交申请失败，失败原因见error的code和userInfo
 */
- (void)commitWithdrawReqWithAmount:(double)amount bankCardID:(NSString *)bankCardID walletID:(NSString *)walletID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 获取当前信用账单

 @param walletID 拥有者id，个人即为个人id，企业即为企业id
 @param resultBlock 结果回调
 */
- (void)fetchCurrentCreditBillByWalletID:(NSString *)walletID result:(void (^)(TCCreditBill *creditBill, NSError *error))resultBlock;

/**
 获取信用账单

 @param resultBlock 结果回调
 */
- (void)fetchCreditBillListByWalletID:(NSString *)walletID limit:(NSInteger)limit sinceTime:(NSString *)sinceTime result:(void (^)(TCCreditBillWrapper *creditBillWrapper, NSError *error))resultBlock;

#pragma mark - 验证码资源

/**
 获取手机验证码
 
 @param phone 手机号码
 @param resultBlock 结果回调，success为NO时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 认证图片信息

 @param imageData 图片数据
 @param resultBlock 回调结果，uploadInfo是上传图片数据所需的信息，uploadInfo为nil时表示认证失败，失败原因见error的code和userInfo
 */
- (void)authorizeImageData:(NSData *)imageData imageType:(TCUploadImageType)imageType result:(void (^)(TCUploadInfo *uploadInfo, NSError *error))resultBlock;

#pragma mark - 商品类资源

/**
 获取商品列表

 @param limitSize 获取的数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCGoodsWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，goodsWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip storeId:(NSString *)storeId result:(void (^)(TCGoodsWrapper *goodsWrapper, NSError *error))resultBlock;

/**
 获取商品详情
 
 @param goodsID 商品的ID
 @param resultBlock 结果回调，TCGoodDetail为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsDetail:(NSString *)goodsID result:(void (^)(TCGoodsDetail *goodsDetail, NSError *error))resultBlock;

/**
 获取商品规格
 
 @param goodsStandardID 商品规格的id
 @param resultBlock 结果回调，goodsStandard为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchGoodsStandard:(NSString *)goodsStandardID result:(void (^)(TCGoodsStandard *goodsStandard, NSError *error))resultBlock;


#pragma mark - 服务类资源

/**
 获取服务列表
 
 @param query query
 @param resultBlock 结果回调，serviceWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchServiceWrapperWithQuery:(NSString *)query result:(void (^)(TCServiceWrapper *serviceWrapper, NSError *error))resultBlock;

/**
 获取商品详情
 
 @param serviceID 服务的ID
 @param resultBlock 结果回调，TCGoodDetail为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchServiceDetail:(NSString *)serviceID result:(void (^)(TCServiceDetail *serviceDetail, NSError *error))resultBlock;


#pragma mark - 订单类资源
/**
 获取商品订单列表
 
 @param status 订单状态
 @param limitSize 获取的数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCOrderWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，TCOrderWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchOrderWrapper:(NSString *)status limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCOrderWrapper *orderWrapper, NSError *error))resultBlock;

/**
 获取商品订单详情

 @param orderID 订单id
 @param resultBlock 结果回调，order为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchOrderDetailWithOrderID:(NSString *)orderID result:(void (^)(TCOrder *order, NSError *error))resultBlock;

/**
 创建商品订单
 
 @param itemList 数组，包含多个字典，字典格式为 @{ amount:2, goodsId:@"xxxxx" }
 @param addressId 收货地址id
 */
- (void)createOrderWithItemList:(NSArray *)itemList AddressId:(NSString *)addressId result:(void(^)(NSArray *orderList, NSError *error))resultBlock;

/**
 创建商品订单

 @param itemList TCOrderCreateItem数组
 @param addressID 收货地址id
 @param isDirect 是否是直接下单
 @param resultBlock 结果回调
 */
- (void)createOrderListWithItemList:(NSArray *)itemList addressID:(NSString *)addressID isDirect:(BOOL)isDirect result:(void(^)(NSArray *orderList, NSError *error))resultBlock;

/**
 更改订单状态
 
 @param statusStr 更改后的状态
 @param orderId  订单id
 */
- (void)changeOrderStatus:(NSString *)statusStr OrderId:(NSString *)orderId result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 更改订单状态（取消订单、收货时使用）

 @param status 需要更改的状态
 @param orderID 订单id
 @param resultBlock 结果回调，success为NO时表示更改失败，失败原因见error的code和userInfo
 */
- (void)changeOrderStatus:(NSString *)status orderID:(NSString *)orderID result:(void(^)(BOOL success, TCOrder *order, NSError *error))resultBlock;


#pragma mark - 服务预订资源
- (void)fetchReservationWrapper:(NSString *)status limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCReservationWrapper *reservationWrapper, NSError *error))resultBlock;

- (void)createReservationWithStoreSetMealId:(NSString *)storeSetMealId appintTime:(NSInteger)appintTime personNum:(NSInteger)personNum linkman:(NSString *)linkman phone:(NSString *)phone note:(NSString *)note vcode:(NSString *)vcode result:(void(^)(TCReservationDetail *reservationDetail, NSError *error))resultBlock;
- (void)fetchReservationDetail:(NSString *)reserveID result:(void (^)(TCReservationDetail *reservationDetail, NSError *error))resultBlock;
- (void)changeReservationStatus:(NSString *)statusStr ReservationId:(NSString *)reservationId result:(void(^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 购物车资源
- (void)fetchShoppingCartWrapperWithSortSkip:(NSString *)sortSkip result:(void (^)(TCShoppingCartWrapper *shoppingCartWrapper, NSError *error))resultBlock;

- (void)changeShoppingCartWithShoppingCartGoodsId:(NSString *)shoppingCartGoodsId AndNewGoodsId:(NSString *)newGoodsId AndAmount:(NSInteger)amount result:(void(^)(TCCartItem *cartItem, NSError *error))resultBlock;

- (void)deleteShoppingCartWithShoppingCartArr:(NSArray *)cartArr result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 添加到购物车

 @param goodsID 商品id
 @param quantity 数量
 @param resultBlock 结果回调
 */
- (void)addToShoppingCartWithGoodsID:(NSString *)goodsID quantity:(NSInteger)quantity result:(void(^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 上传图片资源

/**
 上传图片资源

 @param imageData 要上传的图片数据
 @param progress 上传进度
 @param resultBlock 结果回调，success为NO时表示上传失败，失败原因见error的code和userInfo
 */
- (void)uploadImageData:(NSData *)imageData progress:(void (^)(NSProgress *progress))progress result:(void (^)(BOOL success, TCUploadInfo *uploadInfo, NSError *error))resultBlock;

/**
 上传头像图片资源
 
 @param imageData 要上传的图片数据
 @param progress 上传进度
 @param resultBlock 结果回调，success为NO时表示上传失败，失败原因见error的code和userInfo
 */
- (void)uploadAvatarImageData:(NSData *)imageData progress:(void (^)(NSProgress *progress))progress result:(void (^)(BOOL success, TCUploadInfo *uploadInfo, NSError *error))resultBlock;

#pragma mark - 社区资源

/**
 获取社区列表

 @param resultBlock 结果回调，communityList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchCommunityList:(void (^)(NSArray *communityList, NSError *error))resultBlock;

/**
 获取社区详情

 @param communityID 社区id
 @param resultBlock 结果回调，communityDetailInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchCommunityDetailInfo:(NSString *)communityID result:(void (^)(TCCommunityDetailInfo *communityDetailInfo, NSError *error))resultBlock;

/**
 获取按城市分好组的社区列表

 @param resultBlock 结果回调，communities为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchCommunityListGroupByCity:(void (^)(NSArray *communities, NSError *error))resultBlock;

#pragma mark - 公司资源

/**
 获取社区内的公司列表

 @param communityID 所在社区的ID
 @param resultBlock 结果回调，companyList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchCompanyList:(NSString *)communityID result:(void (^)(NSArray *companyList, NSError *error))resultBlock;

#pragma mark - 物业报修

/**
 获取物业报修列表
 
 @param status 报修订单状态，传nil表示获取全部类型的订单
 @param count  获取数量
 @param sortSkip 默认查询止步的时间和跳过条数，以逗号分隔，如“1478513563773,3”表示查询早于时间1478513563773并跳过后3条记录，首次获取数据和下拉刷新数据时该参数传nil，上拉获取更多数据时该参数传上一次从服务器获取到的TCPropertyManageWrapper对象中属性nextSkip的值
 @param resultBlock 结果回调，propertyManageWrapper为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchPropertyWrapper:(NSString *)status count:(NSUInteger)count sortSkip:(NSString *)sortSkip result:(void (^)(TCPropertyManageWrapper *propertyManageWrapper, NSError *error))resultBlock;

/**
 手机开门
*/
- (void)openDoorWithResult:(void (^)(BOOL, NSError *))resultBlock;



/**
 提交物业报修信息

 @param repairsInfo TCPropertyRepairsInfo对象
 @param resultBlock 结果回调success为NO时表示提交失败，失败原因见error的code和userInfo
 */

- (void)commitPropertyRepairsInfo:(TCPropertyRepairsInfo *)repairsInfo result:(void (^)(BOOL success, TCPropertyManage *propertyManage, NSError *error))resultBlock;


/**
 取消物业报修订单

 @param orderId 订单号
 @param resultBlock 结果回调success为NO时表示提交失败
 */
- (void)cancelPropertyOrderWithOrderID:(NSString *)orderId result:(void(^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 第三方支付

/**
 获取调起微信支付接口所需信息

 @param requestInfo 请求数据
 @param resultBlock 结果回调
 */
- (void)fetchWechatPaymentInfo:(TCWechatPaymentRequestInfo *)requestInfo result:(void(^)(TCWechatPaymentInfo *wechatPaymentInfo, NSError *error))resultBlock;

/**
 获取微信充值结果
 
 @param prepayID 预支付ID，可以在“获取调起微信支付接口所需信息”接口中得到
 @param resultBlock 回调结果，success为NO时表示获取或充值失败，失败原因见error的code和userInfo
 */
- (void)fetchWechatPaymentResultWithPrepayID:(NSString *)prepayID result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 获取宝付SESSION_ID

 @param paymentID 支付申请ID（参见POST /wallets/{id}/payments 返回值id属性），如果传递真实的ID，则完成扣款操作后，金额不再进入余额，而是直接抵扣对应账单金额，同时支付申请关闭并完成所有后继到账处理；如果传递null，则为账户余额充值
 @param resultBlock 回调结果，sessionInfo为nil表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchBFSessionInfoWithPaymentID:(NSString *)paymentID result:(void(^)(TCBFSessionInfo *sessionInfo, NSError *error))resultBlock;

/**
 宝付预支付

 @param payInfo TCBFPayInfo对象
 @param resultBlock 回调结果，payID为nil表示预支付失败，失败原因见error的code和userInfo
 */
- (void)prepareBFPayWithInfo:(TCBFPayInfo *)payInfo result:(void(^)(NSString *payID, NSError *error))resultBlock;

/**
 宝付确认支付

 @param payID 支付id
 @param vCode 短信验证码
 @param resultBlock 回调结果
 */
- (void)confirmBFPayWithPayID:(NSString *)payID vCode:(NSString *)vCode result:(void(^)(TCBFPayResult payResult, NSError *error))resultBlock;

/**
 宝付查询支付

 @param payID 支付id
 @param resultBlock 回调结果
 */
- (void)queryBFPayWithPayID:(NSString *)payID result:(void(^)(TCBFPayResult payResult, NSError *error))resultBlock;



#pragma mark - 门锁设备

/**
 获取自己的锁列表（自己的锁设备列表）

 @param resultBlock 回调
 */
- (void)fetchMyLockListResult:(void (^)(NSArray *lockList, NSError *error))resultBlock;


/**
 获取激活的锁列表（访客列表）

 @param resultBlock 回调
 */
- (void)fetchMyLockKeysResult:(void (^)(NSArray *lockKeysList, NSError *error))resultBlock;

/**
 申请设备的二维码

 @param visitorInfo 访客信息
 @param resultBlock 结果回调
 */
- (void)fetchLockKeyWithVisitorInfo:(TCVisitorInfo *)visitorInfo result:(void(^)(TCLockKey *lockKey, NSError *error))resultBlock;

/**
 清除设备的二维码

 @param lockKeyID 设备二维码id
 @param resultBlock 结果回调
 */
- (void)deleteLockKeyWithID:(NSString *)lockKeyID result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 获取多锁二维码信息

 @param visitorInfo TCVisitorInfo对象
 @param resultBlock 结果回调
 */
- (void)fetchMultiLockKeyWithVisitorInfo:(TCVisitorInfo *)visitorInfo result:(void(^)(TCMultiLockKey *multiLockKey, BOOL hasTooManyLocks, NSError *error))resultBlock;

/**
 清除多锁二维码
 
 @param multiLockKeyID 多锁二维码id
 @param resultBlock 结果回调
 */
- (void)deleteMultiLockKeyWithID:(NSString *)multiLockKeyID result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 查询所有激活状态的设备访客二维码（多锁）

 @param resultBlock 结果回调
 */
- (void)fetchVisitorMultiLockKeyList:(void(^)(NSArray *multiLockKeyList, NSError *error))resultBlock;

#pragma mark - 系统初始化接口

/**
 查询应用上下文信息

 @param resultBlock 结果回调
 */
- (void)fetchAppInitializationInfo:(void(^)(TCAppInitializationInfo *info, NSError *error))resultBlock;

/**
 获取版本信息

 @param resultBlock 结果回调
 */
- (void)fetchAppVersionInfo:(void(^)(TCAppVersion *versionInfo, NSError *error))resultBlock;

/**
 获取首页轮播图

 @param resultBlock 结果回调
 */
- (void)fetchMainPageList:(void(^)(NSArray *mainPageList, NSError *error))resultBlock;

/**
 获取宝付业务支持的银行信息

 @param type 类型
 @param resultBlock 结果回调
 */
- (void)fetchBFSupportedBankListByType:(TCBFSupportedBankType)type result:(void(^)(NSArray *bankCardList, NSError *error))resultBlock;

#pragma mark - 线上活动

/**
 每日签到

 @param resultBlock 结果回调
 */
- (void)signinDaily:(void(^)(TCSigninRecordDay *signinRecordDay, NSError *error))resultBlock;

/**
 查询当月签到记录

 @param resultBlock 结果回调
 */
- (void)fetchSigninRecordMonth:(void(^)(TCSigninRecordMonth *signinRecordMonth, NSError *error))resultBlock;

#pragma mark - 商铺资源

/**
 获取店铺详情

 @param storeId 店铺id
 @param resultBlock 返回店铺信息
 */
- (void)fetchStoreDetailInfoWithStoreId:(NSString *)storeId result:(void (^)(TCStoreDetailInfo *, NSError *))resultBlock;


/**
 获取店铺列表（新版接口）

 @param sellingPointId sellingPointId
 @param limitSize 条数
 @param sortSkip sortSkip
 @param sort 排序
 @param resultBlock 回调
 */
- (void)fetchStoreListWithSellingPointId:(NSString *)sellingPointId limitSize:(NSInteger)limitSize sortSkip:(NSString *)sortSkip sort:(NSString *)sort result:(void(^)(TCStoreWrapper *storeWrapper, NSError *error))resultBlock;

/**
 获取店铺信息（新版接口）

 @param storeID 店铺id
 @param resultBlock 回调结果
 */
- (void)fetchStoreInfoByStoreID:(NSString *)storeID result:(void(^)(TCListStore *storeInfo, NSError *error))resultBlock;

/**
 获取店铺优惠信息（新版接口）

 @param storeID 店铺id
 @param isValid 获取有效优惠还是全部优惠
 @param resultBlock 回调结果
 */
- (void)fetchStorePrivilegeByStoreID:(NSString *)storeID isValid:(BOOL)isValid result:(void(^)(TCListStore *storeInfo, NSError *error))resultBlock;

#pragma mark - 租赁资源

/**
 查询自己的租赁协议列表

 @param resultBlock 结果回调
 */
- (void)fetchRentProtocolList:(void(^)(NSArray *rentProtocolList, NSError *error))resultBlock;

/**
 查询指定房源当前租赁协议

 @param sourceID 房源ID
 @param resultBlock 结果回调
 */
- (void)fetchCurrentRentProtocolBySourceID:(NSString *)sourceID result:(void(^)(TCRentProtocol *rentProtocol, NSError *error))resultBlock;

/**
 查询缴租协议的计划项列表

 @param protocolID 协议ID
 @param resultBlock 结果回调
 */
- (void)fetchRentPlanItemListByRentProtocolID:(NSString *)protocolID result:(void(^)(NSArray *rentPlanItemList, NSError *error))resultBlock;

/**
 修改代扣信息

 @param withholdInfo 改代扣信息
 @param resultBlock 结果回调
 */
- (void)modifyRentProtocolWithholdByRentProtocolID:(NSString *)protocolID withholdInfo:(TCRentProtocolWithholdInfo *)withholdInfo result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 查询代扣信息

 @param protocolID 协议ID
 @param resultBlock 结果回调
 */
- (void)fetchRentProtocolWithholdInfoByRentProtocolID:(NSString *)protocolID result:(void(^)(TCRentProtocolWithholdInfo *withholdInfo, NSError *error))resultBlock;

/**
 清除代扣信息
 
 @param protocolID 协议ID
 @param resultBlock 结果回调
 */
- (void)deleteRentProtocolWithholdByRentProtocolID:(NSString *)protocolID result:(void(^)(BOOL success, NSError *error))resultBlock;


/**
 创建密码

 @param sn 设备号
 @param sourceId 房源Id
 */
- (void)createSmartLockPasswordWithSN:(NSString *)sn sourceId:(NSString *)sourceId password:(NSString *)password result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 查看临时密码

 @param sn 设备号
 @param sourceId 房源id
 */
- (void)checkSmartLockTemporaryPasswordWithSN:(NSString *)sn sourceId:(NSString *)sourceId result:(void(^)(NSString * password, NSError *error))resultBlock;

/**
 获取企业当前缴租协议计划项

 @param resultBlock 结果回调
 */
- (void)fetchCompanyCurrentRentPlanItemByCompanyID:(NSString *)companyID result:(void(^)(NSString *rentProtocolID, TCRentPlanItem *planItem, NSError *error))resultBlock;

#pragma mark - 消息服务

/**
 获取首页消息列表

 @param pullType 拉取方式
 @param count 拉取条数
 @param sinceTime 消息查询时间（获取新消息时传第一条消息的createDate，获取旧消息时传最后一条消息的createDate，第一次获取消息时传0）
 @param resultBlock 结果回调
 */
- (void)fetchHomeMessageWrapperByPullType:(TCDataListPullType)pullType count:(NSInteger)count sinceTime:(int64_t)sinceTime result:(void(^)(TCHomeMessageWrapper *messageWrapper, NSError *error))resultBlock;

/**
 忽略某一条消息

 @param messageID 消息ID
 @param resultBlock 结果回调
 */
- (void)ignoreAHomeMessageByMessageID:(NSString *)messageID result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 忽略某一类型消息

 @param messageType 消息类型
 @param resultBlock 结果回调
 */
- (void)ignoreAParticularTypeHomeMessageByMessageType:(NSString *)messageType result:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 获取用户消息类型开闭状态列表

 @param resultBlock 结果回调
 */
- (void)fetchMessageManagementWrapper:(void(^)(TCMessageManagementWrapper *messageManagementWrapper, NSError *error))resultBlock;

/**
  修改用户消息类型开闭状态

 @param open 开闭状态
 @param messageType 消息类型
 @param resultBlock 结果回调
 */
- (void)modifyMessageState:(BOOL)open messageType:(NSString *)messageType reuslt:(void(^)(BOOL success, NSError *error))resultBlock;

/**
 获取未读消息数
 @param resultBlock 结果回调
 */
- (void)fetchUnReadPushMessageNumberWithResult:(void(^)(NSDictionary *unreadNumDic, NSError *error))resultBlock;


/**
 提交已读消息类型
 @param type 已读类型
 @param resultBlock 结果回调
 */
- (void)postHasReadMessageType:(NSString *)type referenceID:(NSString *)referenceID result:(void(^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 认证信息

/**
 微信登录

 @param code 微信code
 @param resultBlock 结果回调
 */
- (void)loginByWechatCode:(NSString *)code result:(void (^)(BOOL isBind, TCUserSession *userSession, NSError *error))resultBlock;

/**
 微信绑定

 @param code 微信code
 @param userID 用户id
 @param resultBlock 结果回调
 */
- (void)bindWechatByWechatCode:(NSString *)code userID:(NSString *)userID result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 天气信息
/**
 获取天气信息
 
 @param location 位置信息
 @param resultBlock 结果回调
 */
- (void)fetchWeatherDataWithLocation:(NSString *)location result:(void (^)(NSDictionary *weatherDic, NSError *error))resultBlock;

#pragma mark - 会议室预定

/**
 会议室具体日期的预定信息

 @param meetingRoomID 会议室id
 @param searchDate 搜索日期
 @param resultBlock 结果回调
 */
- (void)fetchBookingDateInfoWithMeetingRoomID:(NSString *)meetingRoomID searchDate:(long long)searchDate result:(void (^)(TCBookingDateInfo *bookingDateInfo, NSError *error))resultBlock;


/**
 获取会议室

 @param beginFloor 起始楼层
 @param endFloor 结束楼层
 @param attendance 参会人数
 @param searchBeginDate 开始日期
 @param searchEndDate 结束日期
 @param equipments 设备
 @param duration 时长
 */
- (void)fetchMeetingRoomWithBeginFloor:(NSString *)beginFloor endFloor:(NSString *)endFloor attendance:(NSString *)attendance searchBeginDate:(NSTimeInterval)searchBeginDate searchEndDate:(NSTimeInterval)searchEndDate equipments:(NSString *)equipments duration:(NSString *)duration result:(void (^)(NSArray *meetingRooms, NSError *error))resultBlock;


/**
 获取会议室设备列表

 @param resultBlock 结果回调 meetingRoomsEquipments有值表示成功且有数据
 */
- (void)fetchMeetingRoomEquipmetsWithResult:(void (^)(NSArray *meetingRoomsEquipments, NSError *error))resultBlock;


/**
 获取会议室预定记录

 @param sortSkip sortSkip
 @param limitSize 请求条数
 @param resultBlock 结果回调 meetingRoomReservationWrapper有值表示请求成功
 */
- (void)fetchMeetingRoomReservationWrapperWithSortSkip:(NSString *)sortSkip limitSize:(NSInteger)limitSize result:(void (^)(TCMeetingRoomReservationWrapper *meetingRoomReservationWrapper, NSError *error))resultBlock;


/**
 取消会议室预定

 @param reservationId 预定订单id
 @param resultBlock 结果回调 isSuccess为YES表示取消成功 NO表示取消失败
 */
- (void)cancelMeetingRoomReservationWithID:(NSString *)reservationId result:(void (^)(BOOL isSuccess, NSError *error))resultBlock;


/**
 获取会议室预定详情

 @param reservationId 预定订单id
 @param resultBlock 结果回调 meetingRoomReservationDetail有值表示成功
 */
- (void)fetchMeetingRoomReservationDetailWithID:(NSString *)reservationId result:(void (^)(TCMeetingRoomReservationDetail *meetingRoomReservationDetail, NSError *error))resultBlock;


@end

