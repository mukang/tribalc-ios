//
//  TCMeetingRoomSupportedViewCell.m
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSupportedViewCell.h"
#import "TCMeetingRoomEquipment.h"

@interface TCMeetingRoomSupportedViewCell ()

@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) UILabel *supportedLabel;
@property (weak, nonatomic) UILabel *numLabel;

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *timeIcon;
@property (weak, nonatomic) UIImageView *supportedIcon;
@property (weak, nonatomic) UIImageView *numIcon;

@end

@implementation TCMeetingRoomSupportedViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"会议室套餐";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = TCGrayColor;
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    
    UILabel *supportedLabel = [[UILabel alloc] init];
    supportedLabel.textColor = TCGrayColor;
    supportedLabel.font = [UIFont systemFontOfSize:12];
    supportedLabel.numberOfLines = 0;
    [self.contentView addSubview:supportedLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = TCGrayColor;
    numLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:numLabel];
    
    UIImageView *timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_time_icon"]];
    [self.contentView addSubview:timeIcon];
    
    UIImageView *supportedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_supported_icon"]];
    [self.contentView addSubview:supportedIcon];
    
    UIImageView *numIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_num_icon"]];
    [self.contentView addSubview:numIcon];
    
    self.titleLabel = titleLabel;
    self.timeLabel = timeLabel;
    self.supportedLabel = supportedLabel;
    self.numLabel = numLabel;
    self.timeIcon = timeIcon;
    self.supportedIcon = supportedIcon;
    self.numIcon = numIcon;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeIcon.mas_right).offset(9);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    [self.supportedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.supportedIcon.mas_right).offset(9);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(15);
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numIcon.mas_right).offset(9);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.supportedLabel.mas_bottom).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.left.equalTo(self.titleLabel);
        make.centerY.equalTo(self.timeLabel);
    }];
    [self.supportedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.timeIcon);
        make.top.equalTo(self.supportedLabel).offset(1);
    }];
    [self.numIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(self.timeIcon);
        make.centerY.equalTo(self.numLabel);
    }];
}

- (void)setMeetingRoom:(TCMeetingRoom *)meetingRoom {
    _meetingRoom = meetingRoom;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%d:%02d-%d:%02d开放", meetingRoom.openTime / 3600, meetingRoom.openTime % 3600 / 60, meetingRoom.closeTime / 3600, meetingRoom.closeTime % 3600 / 60];
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:meetingRoom.equipments.count];
    for (TCMeetingRoomEquipment *equipment in meetingRoom.equipments) {
        [tempArray addObject:equipment.name];
    }
    NSString *str = [tempArray componentsJoinedByString:@"  "];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSAttributedString *attText = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                                              NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                              NSParagraphStyleAttributeName: paragraphStyle
                                                                                              }];
    self.supportedLabel.attributedText = attText;
    
    self.numLabel.text = [NSString stringWithFormat:@"可容纳%zd-%zd人", meetingRoom.galleryful, meetingRoom.maxGalleryful];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
