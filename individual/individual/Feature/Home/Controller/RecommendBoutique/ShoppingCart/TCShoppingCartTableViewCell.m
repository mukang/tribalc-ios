//
//  TCShoppingCartTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartTableViewCell.h"

@implementation TCShoppingCartTableViewCell {
    UILabel *countLab;
    UILabel *priceLab;
    UILabel *primaryLab;
    UIButton *secondaryStandardBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        float height = 139;
        float width = [UIScreen mainScreen].bounds.size.width;
        
        _selectedBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
        [self.contentView addSubview:_selectedBtn];
        
        _leftImgView = [self getLeftImageViewWithFrame:CGRectMake(_selectedBtn.x + _selectedBtn.width + 20, height / 2 - 94 / 2, 94, 94)];
        [self.contentView addSubview:_leftImgView];
        
        _titleLab = [TCComponent createLabelWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width + 13, _leftImgView.y + 9, width - _leftImgView.x - _leftImgView.width - 13, 14) AndFontSize:14 AndTitle:@""];
        _titleLab.font = [UIFont fontWithName:BOLD_FONT size:14];
        [self.contentView addSubview:_titleLab];
        
        [self initSeconedStandardButton];
        
        countLab = [TCComponent createLabelWithFrame:CGRectMake(secondaryStandardBtn.x + secondaryStandardBtn.width + 10, secondaryStandardBtn.y + secondaryStandardBtn.height / 2 - 12 / 2, 0, 12) AndFontSize:12 AndTitle:@"" AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
        countLab.font = [UIFont fontWithName:BOLD_FONT size:12];
        [self.contentView addSubview:countLab];
        
        primaryLab = [TCComponent createLabelWithFrame:CGRectMake(_titleLab.x, secondaryStandardBtn.y - 15.5 - 12, _titleLab.width, 12) AndFontSize:12 AndTitle:@"" AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
        [self.contentView addSubview:primaryLab];
        
        priceLab = [TCComponent createLabelWithFrame:CGRectMake(0, height - 28 - 14, 0, 14) AndFontSize:14 AndTitle:@"" AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
        priceLab.font = [UIFont fontWithName:BOLD_FONT size:14];
        [self.contentView addSubview:priceLab];
        
        UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, width - 40, 0.5)];
        [self.contentView addSubview:topLineView];
    }
    
    return self;
}

- (void)initSeconedStandardButton {
    UIButton *seconedStandardImgBtn = [TCComponent createImageBtnWithFrame:CGRectMake(_titleLab.x, 139 - 24.5 - 23, 49.5, 23) AndImageName:@"car_second_button"];
    secondaryStandardBtn = [TCComponent createButtonWithFrame:seconedStandardImgBtn.frame AndTitle:@"" AndFontSize:14 AndBackColor:[UIColor clearColor] AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [self.contentView addSubview:seconedStandardImgBtn];
    [self.contentView addSubview:secondaryStandardBtn];

}


- (void)setStandard:(NSDictionary *)standard {
    NSDictionary *primaryDic = standard[@"primary"];
    NSString *primaryStandard = [NSString stringWithFormat:@"%@ : %@", primaryDic[@"label"], primaryDic[@"types"]];
    primaryLab.text = primaryStandard;
    NSDictionary *secondDic = standard[@"secondary"];
    [secondaryStandardBtn setTitle:secondDic[@"types"] forState:UIControlStateNormal];
}

- (void)setCount:(NSInteger)count {
    NSString *countStr = [NSString stringWithFormat:@"X %li", (long)count];
    countLab.text = countStr;
    [countLab sizeToFit];
}

- (void)setPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    priceStr = [NSString stringWithFormat:@"￥%@", @(priceStr.floatValue)];
    priceLab.text = priceStr;
    [priceLab sizeToFit];
    priceLab.x = [UIScreen mainScreen].bounds.size.width - 20 - priceLab.width;
    
}

- (UIImageView *)getLeftImageViewWithFrame:(CGRect)frame {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    
    return imgView;
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
