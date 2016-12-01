//
//  TCRestaurantSelectButton.h
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCRestaurantSelectButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame AndText:(NSString *)text AndImgName:(NSString *)imgName;

@property (retain, nonatomic) UILabel *titleLab;

@property (retain, nonatomic) UIImageView *imgeView;

@end
