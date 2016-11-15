//
//  TCStandardView.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCStandardView : UIView

@property UILabel *priceLab;
@property UIImageView *titleImageView;
@property UILabel *selectStyleLab;
@property UILabel *selectSizeLab;
@property UILabel *inventoryLab;
@property UILabel *numberLab;


- (instancetype)initWithData:(NSDictionary *)data AndTarget:(id)target AndStyleAction:(SEL)styleAction AndSizeAction:(SEL)sizeAction;
@end
