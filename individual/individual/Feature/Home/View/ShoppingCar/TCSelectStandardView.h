//
//  TCSelectStandardView.h
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "TCModelImport.h"

@interface TCSelectStandardView : UIView <SDWebImageManagerDelegate>

- (instancetype)initWithGood:(TCGoods *)goods AndStandardId:(NSString *)standardId AndRepertory:(NSInteger)repertory AndSelectTag:(NSString *)tag;

@property (retain, nonatomic) UILabel *numberLab;

@property (retain, nonatomic) UILabel *primaryStandardLab;

@property (retain, nonatomic) UILabel *secondaryStandardLab;

@end
