//
//  TCMeetingRoomDeleteContactsViewCell.m
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomDeleteContactsViewCell.h"
#import "TCMeetingRoomContactsView.h"

@interface TCMeetingRoomDeleteContactsViewCell ()

@property (weak, nonatomic) TCMeetingRoomContactsView *contactsView;
@property (weak, nonatomic) UIImageView *selectedView;

@end

@implementation TCMeetingRoomDeleteContactsViewCell

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
    
    UIView *tapView = [[UIView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView)];
    [tapView addGestureRecognizer:tap];
    [self.contentView addSubview:tapView];
    
    UIImageView *selectedView = [[UIImageView alloc] init];
    [tapView addSubview:selectedView];
    self.selectedView = selectedView;
    
    [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11.5, 11.5));
        make.center.equalTo(tapView);
    }];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(65);
        make.top.left.bottom.equalTo(self.contentView);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(tapView.mas_right);
    }];
    [contactsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView.mas_right);
        make.top.right.bottom.equalTo(self.contentView);
    }];
}

- (void)setParticipant:(TCMeetingParticipant *)participant {
    _participant = participant;
    
    self.selectedView.image = participant.isSelected ? [UIImage imageNamed:@"meeting_room_contacts_selected"] : [UIImage imageNamed:@"meeting_room_contacts_normal"];
    self.contactsView.nameLabel.text = participant.name;
    self.contactsView.phoneLabel.text = participant.phone;
}

- (void)handleTapView {
    if ([self.delegate respondsToSelector:@selector(meetingRoomDeleteContactsViewCell:didTapSelectedViewWithParticipant:)]) {
        [self.delegate meetingRoomDeleteContactsViewCell:self didTapSelectedViewWithParticipant:self.participant];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
