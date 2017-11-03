//
//  TCMeetingRoomAddContactsViewCell.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddContactsViewCell.h"

@interface TCMeetingRoomAddContactsViewCell ()

@property (weak, nonatomic) UIImageView *selectedView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *phoneLabel;

@end

@implementation TCMeetingRoomAddContactsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *selectedView = [[UIImageView alloc] init];
    [self.contentView addSubview:selectedView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCBlackColor;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:phoneLabel];
    
    self.selectedView = selectedView;
    self.titleLabel = titleLabel;
    self.phoneLabel = phoneLabel;
}

- (void)setupConstraints {
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11.5, 11.5));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectedView);
        make.left.equalTo(self.selectedView.mas_right).offset(20);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectedView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setParticipant:(TCMeetingParticipant *)participant {
    _participant = participant;
    
    self.selectedView.image = participant.isSelected ? [UIImage imageNamed:@"meeting_room_contacts_selected"] : [UIImage imageNamed:@"meeting_room_contacts_normal"];
    
    self.titleLabel.text = participant.name;
    
    self.phoneLabel.text = participant.phone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
