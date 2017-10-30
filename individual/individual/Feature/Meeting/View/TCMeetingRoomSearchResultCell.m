//
//  TCMeetingRoomSearchResultCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSearchResultCell.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <TCCommonLibs/UIImage+Category.h>

#import "TCMeetingRoom.h"
#import "TCMeetingRoomEquipment.h"

@interface TCMeetingRoomSearchResultCell ()

@property (strong, nonatomic) UIImageView *leftImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *floorLabel;

@property (strong, nonatomic) UILabel *numLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIView *devicesView;

@end

@implementation TCMeetingRoomSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setMeetingRoom:(TCMeetingRoom *)meetingRoom {
    _meetingRoom = meetingRoom;
    
    if ([meetingRoom.pictures isKindOfClass:[NSArray class]] && meetingRoom.pictures.count > 0) {
        NSString *str = meetingRoom.pictures[0];
        if ([str isKindOfClass:[NSString class]]) {
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:str];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(143, 108)];
            [self.leftImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        }
    }
    
    self.titleLabel.text = meetingRoom.name;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld层",(long)meetingRoom.floor]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
//    attch.bounds = CGRectMake(0, -1, 15, 15);
    attch.image = [UIImage imageNamed:@"meeting_room_floor_icon"];
    NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [mutableStr appendAttributedString:att];
    self.floorLabel.attributedText = mutableStr;
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %ld-%ld人",(long)meetingRoom.galleryful,(long)meetingRoom.maxGalleryful]];
    NSTextAttachment *numAttch = [[NSTextAttachment alloc] init];
//    numAttch.bounds = CGRectMake(5, -4, 17, 17);
    numAttch.image = [UIImage imageNamed:@"meeting_room_number_icon"];
    NSAttributedString *numStr = [NSAttributedString attributedStringWithAttachment:numAttch];
    NSMutableAttributedString *mutableNumStr = [[NSMutableAttributedString alloc] initWithAttributedString:numStr];
    [mutableNumStr appendAttributedString:attStr];
    self.numLabel.attributedText = mutableNumStr;
    
    self.priceLabel.text = [NSString stringWithFormat:@"%@元/小时",@(meetingRoom.fee)];
    
    if ([meetingRoom.equipments isKindOfClass:[NSArray class]] && meetingRoom.equipments.count > 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"meeting_room_device_icon"];
        [self.devicesView addSubview:imageView];
        
        CGFloat maxW = TCScreenWidth - 15 - 143 - 15 - 15 - 5 - 15;
        CGFloat margin = 12;
        CGFloat height = 17;
        CGFloat currentX = 20;
        CGFloat currentY = 0;
        for (int i = 0; i < meetingRoom.equipments.count; i++) {
            if (currentY >= (height+10)*2) {
                break;
            }
            TCMeetingRoomEquipment *equ = meetingRoom.equipments[i];
            CGSize size = [equ.name boundingRectWithSize:CGSizeMake(maxW, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
            if (currentX + size.width + 10 + margin > maxW) {
                if (currentY >= (height + 10)) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, maxW-currentX-margin, height)];
                    label.text = @"……";
                    label.textColor = TCGrayColor;
                    label.font = [UIFont systemFontOfSize:11];
                    [self.devicesView addSubview:label];
                    break;
                }else {
                    currentX = 20;
                    currentY += (10+height);
                }
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, size.width+10, height)];
            label.text = equ.name;
            label.textColor = TCGrayColor;
            label.font = [UIFont systemFontOfSize:11];
            label.layer.borderColor = TCGrayColor.CGColor;
            label.layer.borderWidth = 0.5;
            [self.devicesView addSubview:label];
            currentX += (size.width + 10 + margin);
        }
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floorLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.devicesView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.equalTo(@143);
        make.height.equalTo(@108);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(15);
        make.top.equalTo(self.leftImageView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.width.equalTo(@65);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.floorLabel.mas_right);
        make.top.equalTo(self.floorLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.numLabel);
    }];
    
    [self.devicesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.floorLabel.mas_bottom).offset(20);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@45);
    }];
}

- (UIView *)devicesView {
    if (_devicesView == nil) {
        _devicesView = [[UIView alloc] init];
    }
    return _devicesView;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = TCBlackColor;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = TCBlackColor;
    }
    return _numLabel;
}

- (UILabel *)floorLabel {
    if (_floorLabel == nil) {
        _floorLabel = [[UILabel alloc] init];
        _floorLabel.font = [UIFont systemFontOfSize:12];
        _floorLabel.textColor = TCBlackColor;
    }
    return _floorLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TCBlackColor;
    }
    return _titleLabel;
}

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
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
