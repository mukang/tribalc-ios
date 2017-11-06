//
//  TCMeetingRoomRemindViewCell.m
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomRemindViewCell.h"

@interface TCMeetingRoomRemindViewCell ()

@property (weak, nonatomic) UIImageView *remindIcon;

@end

@implementation TCMeetingRoomRemindViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *remindIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_remind_icon"]];
    [self.contentView addSubview:remindIcon];
    
    self.titleLabel = titleLabel;
    self.remindIcon = remindIcon;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];
    [self.remindIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 12.5));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.remindIcon.hidden = !selected;
}

@end
