//
//  TCCompanyIntroViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyIntroViewCell.h"
#import "TCImageURLSynthesizer.h"
#import "TCCompanyInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCCompanyIntroViewCell ()

@property (weak, nonatomic) UIView *logoBgView;
@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *introLabel;
@property (weak, nonatomic) UILabel *fullIntroLabel;
@property (weak, nonatomic) UIButton *unfoldButton;

@property (nonatomic) CGFloat limitWidth;
@property (nonatomic) CGFloat limitHeight;

@end

@implementation TCCompanyIntroViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *logoBgView = [[UIView alloc] init];
    logoBgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.19];
    [self.contentView addSubview:logoBgView];
    self.logoBgView = logoBgView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:logoBgView];
    self.logoImageView = logoImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *introLabel = [[UILabel alloc] init];
    introLabel.textColor = TCRGBColor(42, 42, 42);
    introLabel.font = [UIFont systemFontOfSize:14];
    introLabel.numberOfLines = 5;
    [self.contentView addSubview:introLabel];
    self.introLabel = introLabel;
    
    UILabel *fullIntroLabel = [[UILabel alloc] init];
    fullIntroLabel.textColor = TCRGBColor(42, 42, 42);
    fullIntroLabel.font = [UIFont systemFontOfSize:14];
    fullIntroLabel.numberOfLines = 0;
    fullIntroLabel.hidden = YES;
    [self.contentView addSubview:fullIntroLabel];
    self.fullIntroLabel = fullIntroLabel;
    
    UIButton *unfoldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unfoldButton setImage:[UIImage imageNamed:@"company_intro_unfold_button"] forState:UIControlStateNormal];
    [unfoldButton addTarget:self action:@selector(handleClickUnfoldButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:unfoldButton];
    self.unfoldButton = unfoldButton;
    
    CGFloat padding = TCRealValue(39);
    _limitWidth = TCScreenWidth - padding * 2.0;
    CGRect tempRect = CGRectMake(0, 0, _limitWidth, CGFLOAT_MAX);
    _limitHeight = [self.introLabel textRectForBounds:tempRect limitedToNumberOfLines:5].size.height;
}

- (void)setCompanyInfo:(TCCompanyInfo *)companyInfo {
    _companyInfo = companyInfo;
    
    NSURL *logoURL = [TCImageURLSynthesizer synthesizeImageURLWithPath:companyInfo.logo];
    [self.logoImageView sd_setImageWithURL:logoURL placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.nameLabel.text = companyInfo.name;
    
    self.introLabel.text = companyInfo.desc;
    self.fullIntroLabel.text = companyInfo.desc;
    
    CGFloat introHeight = [companyInfo.desc boundingRectWithSize:CGSizeMake(self.limitWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:@{
                                                                   NSForegroundColorAttributeName: TCRGBColor(42, 42, 42),
                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                   }
                                                         context:nil].size.height;
    if (introHeight <= self.limitHeight) {
        self.unfoldButton.hidden = YES;
    } else {
        self.unfoldButton.hidden = NO;
    }
}

- (void)setUnfold:(BOOL)unfold {
    _unfold = unfold;
    
    if (unfold) {
        self.introLabel.hidden = YES;
        self.fullIntroLabel.hidden = NO;
        [self.unfoldButton setImage:[UIImage imageNamed:@"company_intro_fold_button"] forState:UIControlStateNormal];
    } else {
        self.introLabel.hidden = NO;
        self.fullIntroLabel.hidden = YES;
        [self.unfoldButton setImage:[UIImage imageNamed:@"company_intro_unfold_button"] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.contentView.width;
    
    self.logoBgView.size = CGSizeMake(67, 67);
    self.centerX = width * 0.5;
    self.centerY = 0;
    self.logoBgView.layer.cornerRadius = self.logoBgView.width * 0.5;
    self.logoBgView.layer.masksToBounds = YES;
    
    self.logoImageView.frame = CGRectInset(self.logoBgView.frame, 3, 3);
    self.logoImageView.layer.cornerRadius = self.logoImageView.width * 0.5;
    self.logoImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(0, 24.5, width, 19);
    
    CGFloat labelX = TCRealValue(39);
    CGFloat labelY = 55;
    
    CGFloat introHeight = [self.companyInfo.desc boundingRectWithSize:CGSizeMake(self.limitWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           attributes:@{
                                                                        NSForegroundColorAttributeName: TCRGBColor(42, 42, 42),
                                                                        NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                        }
                                                              context:nil].size.height;
    CGFloat labelHeight = (introHeight <= self.limitHeight) ? introHeight : self.limitHeight;
    self.introLabel.frame = CGRectMake(labelX, labelY, self.limitWidth, labelHeight);
    
    self.fullIntroLabel.frame = CGRectMake(labelX, labelY, self.limitWidth, introHeight);
    
    CGFloat buttonY;
    if (self.unfold) {
        buttonY = CGRectGetMaxY(self.fullIntroLabel.frame) + 14;
    } else {
        buttonY = CGRectGetMaxY(self.introLabel.frame) + 14;
    }
    self.unfoldButton.size = CGSizeMake(15, 8.5);
    self.unfoldButton.centerX = width * 0.5;
    self.unfoldButton.y = buttonY;
}

- (void)handleClickUnfoldButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(companyIntroViewCell:didClickUnfoldButtonWithUnfold:)]) {
        [self.delegate companyIntroViewCell:self didClickUnfoldButtonWithUnfold:self.unfold];
    }
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withCompanyInfo:(TCCompanyInfo *)companyInfo unfold:(BOOL)unfold {
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = TCRGBColor(42, 42, 42);
    tempLabel.font = [UIFont systemFontOfSize:14];
    tempLabel.numberOfLines = 5;
    tempLabel.text = companyInfo.desc;
    
    CGFloat padding = TCRealValue(39);
    CGFloat limitWidth = TCScreenWidth - padding * 2.0;
    CGRect tempRect = CGRectMake(0, 0, limitWidth, CGFLOAT_MAX);
    CGFloat limitHeight = [tempLabel textRectForBounds:tempRect limitedToNumberOfLines:5].size.height;
    
    CGFloat introHeight = [companyInfo.desc boundingRectWithSize:CGSizeMake(limitWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      attributes:@{
                                                                   NSForegroundColorAttributeName: TCRGBColor(42, 42, 42),
                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                   }
                                                         context:nil].size.height;
    
    CGFloat topMargin = 55;
    CGFloat bottomMargin;
    CGFloat realHeight;
    if (introHeight <= limitHeight) {
        realHeight = introHeight;
        bottomMargin = 14;
    } else {
        bottomMargin = 32;
        if (unfold) {
            realHeight = introHeight;
        } else {
            realHeight = limitHeight;
        }
    }
    
    return topMargin + realHeight + bottomMargin;
}

@end
