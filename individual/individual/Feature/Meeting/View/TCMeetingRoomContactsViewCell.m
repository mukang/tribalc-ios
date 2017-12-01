//
//  TCMeetingRoomContactsViewCell.m
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsViewCell.h"

@interface TCMeetingRoomContactsViewCell ()

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *phoneLabel;

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
    
    MGSwipeButton *deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:TCRGBColor(252, 68, 68)];
    [deleteButton setEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    self.rightButtons = @[deleteButton];
    self.rightSwipeSettings.transition = MGSwipeTransitionDrag;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCBlackColor;
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:phoneLabel];
    
    self.nameLabel = nameLabel;
    self.phoneLabel = phoneLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(phoneLabel.mas_left).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [phoneLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [phoneLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setParticipant:(TCMeetingParticipant *)participant {
    _participant = participant;
    
    self.nameLabel.text = participant.name;
    self.phoneLabel.text = participant.phone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
