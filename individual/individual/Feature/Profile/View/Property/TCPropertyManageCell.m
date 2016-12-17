//
//  TCPropertyManageCell.m
//  individual
//
//  Created by 王帅锋 on 16/12/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPropertyManageCell.h"

@interface TCPropertyManageCell ()
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;
@property (weak, nonatomic) IBOutlet UILabel *appiontTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *doorTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *masterInfoConstraintHeight;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *finishedImage;

@end


@implementation TCPropertyManageCell

- (void)setPropertyManage:(TCPropertyManage *)propertyManage {
    if (propertyManage != _propertyManage) {
        _propertyManage = propertyManage;
        
        NSTimeInterval appointTime = propertyManage.appointTime/1000;
        NSDate *appointDate = [NSDate dateWithTimeIntervalSince1970:appointTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSTimeInterval doorTime = propertyManage.doorTime/1000;
        NSDate *doorDate = [NSDate dateWithTimeIntervalSince1970:doorTime];
        _communityNameLabel.text = propertyManage.communityName ? propertyManage.communityName : @"";
        _companyNameLabel.text =  propertyManage.companyName ? propertyManage.companyName : @"";
        _applyPersonNameLabel.text = propertyManage.applyPersonName ? propertyManage.applyPersonName : @"";
        _floorLabel.text = propertyManage.floor ? [NSString stringWithFormat:@"%@层",propertyManage.floor] : @"";
        _appiontTimeLabel.text = [formatter stringFromDate:appointDate];
        _phoneLabel.text = propertyManage.phone;
        _masterPersonNameLabel.text = propertyManage.masterPersonName ? propertyManage.masterPersonName : @"";
        _doorTimeLabel.text = [formatter stringFromDate:doorDate];
        _masterView.hidden = [propertyManage.status isEqualToString:@"ORDER_ACCEPT"];
        if (propertyManage.status) {
            if ([propertyManage.status isEqualToString:@"ORDER_ACCEPT"]) {
                [_statusBtn setTitle:@"系统接单" forState:UIControlStateNormal];
                _finishedImage.hidden = YES;
            }else if ([propertyManage.status isEqualToString:@"TASK_CONFIRM"]) {
                [_statusBtn setTitle:@"任务确认" forState:UIControlStateNormal];
                _finishedImage.hidden = YES;
            }else if ([propertyManage.status isEqualToString:@"NOT_PAYING"]) {
                [_statusBtn setTitle:@"待付款" forState:UIControlStateNormal];
                _finishedImage.hidden = YES;
            }else if ([propertyManage.status isEqualToString:@"PAYED"]) {
                [_statusBtn setTitle:@"" forState:UIControlStateNormal];
                _finishedImage.hidden= NO;
            }else {
                [_statusBtn setTitle:@"" forState:UIControlStateNormal];
                _finishedImage.hidden = YES;
            }
        }else {
            [_statusBtn setTitle:@"" forState:UIControlStateNormal];
            _finishedImage.hidden = YES;
        }
        
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
