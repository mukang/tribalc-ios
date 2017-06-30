//
//  TCApartmentCell.h
//  individual
//
//  Created by 王帅锋 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRentProtocol.h"

#define kScale ([UIScreen mainScreen].bounds.size.width > 375 ? 3.0 : 2.0)
#define kLineColor TCRGBColor(221, 221, 221)

@protocol TCApartmentCellDelegate <NSObject>

/** 缴费 */
- (void)didClickFeeWithRentProtocol:(TCRentProtocol *)rentProtocol;

/** 点击我的合同 */
- (void)didClickCheckContractWithRentProtocol:(TCRentProtocol *)rentProtocol;

/** 修改密码 */
- (void)didClickModifyPwdWithRentProtocol:(TCRentProtocol *)rentProtocol;

/** 查看临时密码 */
- (void)didClickCheckPwdWithRentProtocol:(TCRentProtocol *)rentProtocol;

/** 查看电量 */
- (void)didClickCheckElecWithRentProtocol:(TCRentProtocol *)rentProtocol;

/** 还款计划 */
- (void)didClickCheckPayPlanWithRentProtocol:(TCRentProtocol *)rentProtocol;

@end

@interface TCApartmentCell : UITableViewCell

@property (strong, nonatomic) TCRentProtocol *rentProtocol;

@property (weak, nonatomic) id<TCApartmentCellDelegate> delegate;

@end
