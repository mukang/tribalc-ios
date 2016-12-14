//
//  TCUserReserveTableViewCell.m
//  individual
//
//  Created by WYH on 16/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserReserveTableViewCell.h"
#import "TCComponent.h"

@implementation TCUserReserveTableViewCell {
    UILabel *brandLab;
    UILabel *placeLab;
    UILabel *titleLab;
    UIView *brandCenterPlaceView;
    UIView *timeView;
    UIView *personNumberView;
}

- (instancetype)initReserveDetail {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail"];
    _storeImageView.frame = CGRectMake(TCRealValue(_storeImageView.x + 8), TCRealValue(131) / 2 - TCRealValue(109.5) / 2, TCRealValue(_storeImageView.width - 8), TCRealValue(109.5));
    titleLab.frame = CGRectMake(_storeImageView.x + _storeImageView.width + TCRealValue(20), TCRealValue(17.5), TCScreenWidth - _storeImageView.x - _storeImageView.width - TCRealValue(20), 14);
    brandLab.frame = CGRectMake(titleLab.x, titleLab.y + titleLab.height + TCRealValue(17.5), 0, 11);
    brandCenterPlaceView.frame = CGRectMake(0, brandLab.y + 1, 0.5, 11);
    placeLab.frame = CGRectMake(0, brandLab.y, 0, 0);
    
    timeView.frame = CGRectMake(titleLab.x, TCRealValue(131) - TCRealValue(44) - 11, TCScreenWidth - titleLab.x, 11);
    personNumberView.frame = CGRectMake(titleLab.x, TCRealValue(131) - TCRealValue(25) - 11, timeView.width, 11);
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, TCScreenWidth, 0.5)];
    [self.contentView addSubview:topLineView];
    UIView *bottomView = [self getTableBottomViewWithFrame:CGRectMake(0, TCRealValue(131), TCScreenWidth, 11)];
    [self.contentView addSubview:bottomView];
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
        _storeImageView = [self getStoreImageViewWithFrame:CGRectMake(TCRealValue(22.5), TCRealValue(143) / 2 - TCRealValue(115) / 2, TCRealValue(169), TCRealValue(115))];
        [self.contentView addSubview:_storeImageView];
        
        titleLab = [self getTitleLabWithFrame:CGRectMake(_storeImageView.x + _storeImageView.width + 20, TCRealValue(22.5), TCScreenWidth - _storeImageView.x - _storeImageView.width - 20 - 20, 14)];
        [self.contentView addSubview:titleLab];
        
        brandLab = [TCComponent createLabelWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + TCRealValue(10), 0, 0) AndFontSize:11 AndTitle:@""];
        [self.contentView addSubview:brandLab];
        
        brandCenterPlaceView = [TCComponent createGrayLineWithFrame:CGRectMake(0, titleLab.y + titleLab.height + TCRealValue(10) + 1, 0.5, 11)];
        [self.contentView addSubview:brandCenterPlaceView];
        
        placeLab = [TCComponent createLabelWithFrame:CGRectMake(0, titleLab.y + titleLab.height + TCRealValue(10), 0, 0) AndFontSize:11 AndTitle:@""];
        [self.contentView addSubview:placeLab];
        
        timeView = [self getTimeOrPersonNumberViewWtihFrame:CGRectMake(titleLab.x, TCRealValue(143) - TCRealValue(50) - 11, TCScreenWidth - titleLab.x, 11) AndTitle:@"时间" ];
        [self.contentView addSubview:timeView];
        
        personNumberView = [self getTimeOrPersonNumberViewWtihFrame:CGRectMake(titleLab.x, TCRealValue(143) - TCRealValue(30) - 11, timeView.width, 11) AndTitle:@"人数" ];
        [self.contentView addSubview:personNumberView];
        
    }
    
    return self;
}


- (UIView *)getTableBottomViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = TCRGBColor(242, 242, 242);
    UIView *bottomLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, view.height - 0.5, view.width, 0.5)];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, view.width, 0.5)];
    [view addSubview:bottomLineView];
    [view addSubview:topLineView];
    
    return view;
}



- (void)setDetailBrandLabText:(NSString *)text {
    brandLab.text = text;
    [brandLab sizeToFit];
    brandLab.y = titleLab.y + titleLab.height + TCRealValue(17.5);
    brandCenterPlaceView.y = brandLab.y + 1;
    brandCenterPlaceView.x = brandLab.x + brandLab.width + 2;
    placeLab.x = brandCenterPlaceView.x + brandCenterPlaceView.width + 2;
    placeLab.y = brandLab.y;
}

- (void)setBrandLabText:(NSString *)text {
    brandLab.text = text;
    [brandLab sizeToFit];
    brandLab.y = titleLab.y + titleLab.height + TCRealValue(10);
    brandCenterPlaceView.x = brandLab.x + brandLab.width + 2;
    brandCenterPlaceView.y = brandLab.y + 1;
    placeLab.x = brandCenterPlaceView.x + brandCenterPlaceView.width + 2;
}

- (void)setDetailPlaceLabText:(NSString *)text {
    placeLab.text = text;
    [placeLab sizeToFit];
    placeLab.y = titleLab.y + titleLab.height + TCRealValue(17.5);
    placeLab.x = brandCenterPlaceView.x + brandCenterPlaceView.width + 2;
}

- (void)setPlaceLabText:(NSString *)text {
    placeLab.text = text;
    [placeLab sizeToFit];
    placeLab.y = titleLab.y + titleLab.height + TCRealValue(10);
    placeLab.x = brandCenterPlaceView.x + brandCenterPlaceView.width + 2;
}

- (void)setTitleLabText:(NSString *)text {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
    if (size.width > titleLab.width - 20) {
        titleLab.y = 17.5;
        titleLab.height = 14 * 2 + 5;
        titleLab.numberOfLines = 2;
        titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    titleLab.text = text;
    NSInteger y = titleLab.y + titleLab.height + 10;
    brandLab.y = y;
    placeLab.y = y;
    brandCenterPlaceView.y = y + 1;
}

- (UIView *)getTimeOrPersonNumberViewWtihFrame:(CGRect)frame AndTitle:(NSString *)title{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *tagLab = [TCComponent createLabelWithFrame:CGRectMake(0, 0, 24, frame.size.height) AndFontSize:11 AndTitle:title AndTextColor:TCRGBColor(154, 154, 154)];
    [view addSubview:tagLab];
    
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(tagLab.x + tagLab.width + 3, 0, view.width - tagLab.x - tagLab.width - 3, view.height) AndFontSize:11 AndTitle:@"" AndTextColor:TCRGBColor(42, 42, 42)];
    [view addSubview:label];
    if ([title isEqualToString:@"时间"]) {
        _timeLab = label;
    } else {
        _personNumberLab = label;
    }
    
    return view;
}

- (UILabel *)getTitleLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:BOLD_FONT size:14];
    label.textColor = TCRGBColor(42, 42, 42);
    
    
    return label;
}

- (UIImageView *)getStoreImageViewWithFrame:(CGRect)frame {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.layer.cornerRadius = 30;
    
    
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
