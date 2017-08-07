//
//  TCWalletFeaturesView.h
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCWalletFeaturesViewType) {
    TCWalletFeaturesViewTypeIndividual = 0,
    TCWalletFeaturesViewTypeCompany
};

@protocol TCWalletFeaturesViewDelegate;
@interface TCWalletFeaturesView : UIView

@property (nonatomic, readonly) TCWalletFeaturesViewType type;
@property (weak, nonatomic) id<TCWalletFeaturesViewDelegate> delegate;

- (instancetype)initWithType:(TCWalletFeaturesViewType)type;

@end


@protocol TCWalletFeaturesViewDelegate <NSObject>

@optional
- (void)walletFeaturesView:(TCWalletFeaturesView *)view didClickFeatureButtonWithIndex:(NSInteger)index;

@end
