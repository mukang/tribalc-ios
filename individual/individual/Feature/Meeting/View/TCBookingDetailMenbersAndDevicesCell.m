//
//  TCBookingDetailMenbersAndDevicesCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailMenbersAndDevicesCell.h"
#import "TCMeetingRoomReservationDetail.h"
#import "TCMeetingRoomEquipment.h"
#import "TCMeetingParticipant.h"

@interface TCBookingDetailMenbersAndDevicesCell ()

@property (strong, nonatomic) UILabel *menbersTitleLabel;

@property (strong, nonatomic) UIView *menbersView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *openTimeTitleLabel;

@property (strong, nonatomic) UILabel *openTimeLabel;

@property (strong, nonatomic) UILabel *deviceTitleLabel;

@property (strong, nonatomic) UILabel *devicesLabel;

@property (strong, nonatomic) UILabel *numberTitleLabel;

@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation TCBookingDetailMenbersAndDevicesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)showParticipant {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickShowParticipants)]) {
        [self.delegate didClickShowParticipants];
    }
}

- (void)setMeetingRoomReservationDetail:(TCMeetingRoomReservationDetail *)meetingRoomReservationDetail {
    _meetingRoomReservationDetail = meetingRoomReservationDetail;
    for (UIView *view in self.menbersView.subviews) {
        [view removeFromSuperview];
    }
    //参会人
    if ([meetingRoomReservationDetail.conferenceParticipants isKindOfClass:[NSArray class]] && meetingRoomReservationDetail.conferenceParticipants.count > 0) {
        UILabel *lastL;
        for (int i = 0; i<meetingRoomReservationDetail.conferenceParticipants.count; i++) {
            TCMeetingParticipant *participant = meetingRoomReservationDetail.conferenceParticipants[i];
            UILabel *nameL= [[UILabel alloc] init];
            nameL.textColor = TCBlackColor;
            nameL.font = [UIFont systemFontOfSize:14];
            
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",participant.name]];
            NSTextAttachment *nameAttch = [[NSTextAttachment alloc] init];
            nameAttch.bounds = CGRectMake(0, -1, 9, 11);
            nameAttch.image = [UIImage imageNamed:@"meeting_room_number_icon"];
            NSAttributedString *nameStr = [NSAttributedString attributedStringWithAttachment:nameAttch];
            NSMutableAttributedString *mutableNameStr = [[NSMutableAttributedString alloc] initWithAttributedString:nameStr];
            [mutableNameStr appendAttributedString:attStr];
            nameL.attributedText = mutableNameStr;
            
            UILabel *phoneL = [[UILabel alloc] init];
            phoneL.textColor = TCBlackColor;
            phoneL.font = [UIFont systemFontOfSize:14];
            
            NSAttributedString *phoneAttStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",participant.phone]];
            NSTextAttachment *phoneAttch = [[NSTextAttachment alloc] init];
            phoneAttch.bounds = CGRectMake(0, -1, 9, 11);
            phoneAttch.image = [UIImage imageNamed:@"meeting_room_phone_icon"];
            NSAttributedString *phoneStr = [NSAttributedString attributedStringWithAttachment:phoneAttch];
            NSMutableAttributedString *mutablePhoneStr = [[NSMutableAttributedString alloc] initWithAttributedString:phoneStr];
            [mutablePhoneStr appendAttributedString:phoneAttStr];
            phoneL.attributedText = mutablePhoneStr;
            
            [self.menbersView addSubview:nameL];
            [self.menbersView addSubview:phoneL];
            
            if (i == 0) {
                [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.menbersView);
                    make.top.equalTo(self.menbersView).offset(20);
                    make.width.equalTo(@75);
                    make.height.equalTo(@15);
                }];
            }else if (i == meetingRoomReservationDetail.conferenceParticipants.count - 1) {
                [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.menbersView);
                    make.top.equalTo(lastL.mas_bottom).offset(10);
                    make.width.height.equalTo(lastL);
                    make.bottom.equalTo(self.menbersView).offset(-15);
                }];
            }else {
                [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.width.height.equalTo(lastL);
                    make.top.equalTo(lastL.mas_bottom).offset(10);
                }];
            }
            
            [phoneL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nameL.mas_right);
                make.height.top.equalTo(nameL);
            }];
            
            lastL = nameL;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"meeting_room_show_participant"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showParticipant) forControlEvents:UIControlEventTouchUpInside];
        [self.menbersView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.menbersView);
            make.centerY.equalTo(self.menbersView);
            make.width.height.equalTo(@25);
        }];
    }
    
    NSInteger openH = meetingRoomReservationDetail.openTime/3600;
    NSInteger openM = (meetingRoomReservationDetail.openTime%3600)/60;
    NSInteger closeH = meetingRoomReservationDetail.closeTime/3600;
    NSInteger closeM = (meetingRoomReservationDetail.closeTime%3600)/60;
    self.openTimeLabel.text = [NSString stringWithFormat:@"%ld:%.2ld-%ld:%.2ld",(long)openH, (long)openM,(long)closeH,(long)closeM];
    
    if ([meetingRoomReservationDetail.equipmentList isKindOfClass:[NSArray class]] && meetingRoomReservationDetail.equipmentList.count > 0) {
        NSMutableString *mutabelStr = [NSMutableString stringWithCapacity:0];
        for (TCMeetingRoomEquipment *equ in meetingRoomReservationDetail.equipmentList) {
            if ([equ.name isKindOfClass:[NSString class]]) {
                [mutabelStr appendString:equ.name];
                [mutabelStr appendString:@" "];
            }
        }
        self.devicesLabel.text = mutabelStr;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"可容纳%ld-%ld人",(long)meetingRoomReservationDetail.galleryful,(long)meetingRoomReservationDetail.maxGalleryful];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.menbersTitleLabel];
    [self.contentView addSubview:self.menbersView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.openTimeTitleLabel];
    [self.contentView addSubview:self.openTimeLabel];
    [self.contentView addSubview:self.deviceTitleLabel];
    [self.contentView addSubview:self.devicesLabel];
    [self.contentView addSubview:self.numberTitleLabel];
    [self.contentView addSubview:self.numberLabel];
    
    [self.menbersTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.menbersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel.mas_right).offset(5);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.greaterThanOrEqualTo(@50);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.menbersView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.openTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
    }];
    
    [self.openTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.openTimeTitleLabel.mas_right);
        make.top.equalTo(self.openTimeTitleLabel);
    }];
    
    [self.deviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel);
        make.top.equalTo(self.openTimeTitleLabel.mas_bottom).offset(10);
    }];
    
    [self.devicesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceTitleLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.deviceTitleLabel);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel);
        make.top.equalTo(self.devicesLabel.mas_bottom).offset(10);
        make.height.equalTo(@15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberTitleLabel.mas_right);
        make.top.equalTo(self.numberTitleLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = TCBlackColor;
//        _numberLabel.text = @"可容纳6-8人";
    }
    return _numberLabel;
}

- (UILabel *)numberTitleLabel {
    if (_numberTitleLabel == nil) {
        _numberTitleLabel = [[UILabel alloc] init];
        _numberTitleLabel.textColor = TCGrayColor;
        _numberTitleLabel.font = [UIFont systemFontOfSize:14];
        _numberTitleLabel.text = @"容纳人数：";
    }
    return _numberTitleLabel;
}

- (UILabel *)devicesLabel {
    if (_devicesLabel == nil) {
        _devicesLabel = [[UILabel alloc] init];
        _devicesLabel.textColor = TCBlackColor;
        _devicesLabel.font = [UIFont systemFontOfSize:14];
        _devicesLabel.numberOfLines = 0;
        [_devicesLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        _devicesLabel.text = @"投影仪  窗户  矿泉人  白板  桌子  椅子  纸笔  柠檬茶  玫瑰茶  无线网络";
    }
    return _devicesLabel;
}

- (UILabel *)deviceTitleLabel {
    if (_deviceTitleLabel == nil) {
        _deviceTitleLabel = [[UILabel alloc] init];
        _deviceTitleLabel.textColor = TCGrayColor;
        _deviceTitleLabel.font = [UIFont systemFontOfSize:14];
        _deviceTitleLabel.text = @"配套设施：";
        [_deviceTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _deviceTitleLabel;
}

- (UILabel *)openTimeLabel {
    if (_openTimeLabel == nil) {
        _openTimeLabel = [[UILabel alloc] init];
        _openTimeLabel.textColor = TCBlackColor;
        _openTimeLabel.font = [UIFont systemFontOfSize:14];
        _openTimeLabel.text = @"9:00-20:00";
    }
    return _openTimeLabel;
}

- (UILabel *)openTimeTitleLabel {
    if (_openTimeTitleLabel == nil) {
        _openTimeTitleLabel = [[UILabel alloc] init];
        _openTimeTitleLabel.textColor = TCGrayColor;
        _openTimeTitleLabel.text = @"开放时间：";
        _openTimeTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _openTimeTitleLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView;
}

- (UIView *)menbersView {
    if (_menbersView == nil) {
        _menbersView = [[UIView alloc] init];
    }
    return _menbersView;
}

- (UILabel *)menbersTitleLabel {
    if (_menbersTitleLabel == nil) {
        _menbersTitleLabel = [[UILabel alloc] init];
        _menbersTitleLabel.textColor = TCGrayColor;
        _menbersTitleLabel.font = [UIFont systemFontOfSize:14];
        _menbersTitleLabel.text = @"参  会  人：";
    }
    return _menbersTitleLabel;
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
