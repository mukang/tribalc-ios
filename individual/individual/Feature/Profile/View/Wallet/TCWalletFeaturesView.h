//
//  TCWalletFeaturesView.h
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCWalletFeatureType) {
    TCWalletFeatureTypeRecharge = 0,
    TCWalletFeatureTypeWithdraw,
    TCWalletFeatureTypeCredit,
    TCWalletFeatureTypeBankCard,
    TCWalletFeatureTypeSweepCode,
    TCWalletFeatureTypeStatement,
    TCWalletFeatureTypeCoupon,
    TCWalletFeatureTypeFinance,
    TCWalletFeatureTypePassword
};

@protocol TCWalletFeaturesViewDelegate;
@interface TCWalletFeaturesView : UIView

@property (weak, nonatomic) id<TCWalletFeaturesViewDelegate> delegate;

@end


@protocol TCWalletFeaturesViewDelegate <NSObject>

@optional
- (void)walletFeaturesView:(TCWalletFeaturesView *)view didClickFeatureButtonWithType:(TCWalletFeatureType)type;

@end
