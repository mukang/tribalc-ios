//
//  TCRestaurantTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantTableViewCell.h"

@implementation TCRestaurantTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float cellWidth = [UIScreen mainScreen].bounds.size.width;
        
        [self initialImgView];
        
        _nameLab = [self createLabWithFrame:CGRectMake(_resImgView.origin.x + _resImgView.size.width + 20, _resImgView.origin.y + 2, cellWidth - _resImgView.origin.x - _resImgView.size.width - 20, 18) AndFontSize:17 AndTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_nameLab];
        
        _locationAndTypeLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x - 5, _nameLab.origin.y + _nameLab.size.height + 8, _nameLab.size.width, 14) AndFontSize:13 AndTextColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1]];
        [self.contentView addSubview:_locationAndTypeLab];
        
        
        _priceLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x, _resImgView.origin.y + _resImgView.size.height - 25, 100, 20) AndFontSize:19 AndTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_priceLab];
        
        [self initialRangeLab];
        
        _privateRoomBtn = [self createRestaurantButtonWithFrame:CGRectMake(_locationAndTypeLab.origin.x, _locationAndTypeLab.origin.y + _locationAndTypeLab.size.height + 7, 47, 29) AndText:@"包间"];
        [self.contentView addSubview:_privateRoomBtn];
        
        _reserveBtn = [self createRestaurantButtonWithFrame:CGRectMake(_privateRoomBtn.origin.x + _privateRoomBtn.size.width + 10, _privateRoomBtn.origin.y, _privateRoomBtn.size.width, _privateRoomBtn.size.height) AndText:@"订座"];
        [self.contentView addSubview:_reserveBtn];
        
    }
    return self;
}


- (void)showRestaurantButton {
    if (_privateRoomBtn.hidden == YES && _reserveBtn.hidden == NO) {
        _reserveBtn.origin = _privateRoomBtn.origin;
    }
}

- (UIButton *)createRestaurantButtonWithFrame:(CGRect)frame AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 1;
    button.layer.borderColor = _locationAndTypeLab.textColor.CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.hidden = YES;
    return button;
    
}

- (void)initialRangeLab {
    _rangeLab = [self createLabWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 80 - 12, _priceLab.origin.y, 80, 15) AndFontSize:14 AndTextColor:_locationAndTypeLab.textColor];
    _rangeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rangeLab];
}

- (void)initialImgView {
    float cellWidth = [UIScreen mainScreen].bounds.size.width;
    float cellHeight = 165;
    
    _resImgView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 15, cellWidth / 2 - 10, cellHeight - 15 - 18)];
    [self.contentView addSubview:_resImgView];
}

- (UILabel *)createLabWithFrame:(CGRect)frame AndFontSize:(float)font AndTextColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:font];
    label.textColor = textColor;
    
    return label;
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
