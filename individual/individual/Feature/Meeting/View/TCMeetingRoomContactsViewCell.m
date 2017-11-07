//
//  TCMeetingRoomContactsViewCell.m
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsViewCell.h"
#import "TCMeetingRoomContactsView.h"

@interface TCMeetingRoomContactsViewCell ()

@property (weak, nonatomic) TCMeetingRoomContactsView *contactsView;

@end

@implementation TCMeetingRoomContactsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    TCMeetingRoomContactsView *contactsView = [[TCMeetingRoomContactsView alloc] init];
    [self.contentView addSubview:contactsView];
    self.contactsView = contactsView;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self.contentView addSubview:lineView];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_contacts_avatar"]];
    [self.contentView addSubview:avatarView];
    
    [contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-65);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(contactsView.mas_right);
    }];
    [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47.5, 47.5));
        make.centerY.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView.mas_right).offset(-32.5);
    }];
}

- (void)setParticipant:(TCMeetingParticipant *)participant {
    _participant = participant;
    
    self.contactsView.nameLabel.text = participant.name;
    self.contactsView.phoneLabel.text = participant.phone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
