//
//  TCCommunityIntroViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityIntroViewCell.h"
#import "TCCommunityDetailInfo.h"

@interface TCCommunityIntroViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;

@end

@implementation TCCommunityIntroViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCommunityDetailInfo:(TCCommunityDetailInfo *)communityDetailInfo {
    _communityDetailInfo = communityDetailInfo;
    
    self.nameLabel.text = communityDetailInfo.name;
    self.addressLabel.text = communityDetailInfo.address;
//    self.descLabel.text = communityDetailInfo.desc;
    if (communityDetailInfo.desc) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:communityDetailInfo.desc
                                                                        attributes:@{
                                                                                     NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                     NSForegroundColorAttributeName: TCBlackColor,
                                                                                     NSParagraphStyleAttributeName: paragraphStyle
                                                                                     }];
    }
}

- (IBAction)handleClickVisitButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(communityIntroViewCell:didClickVisitButtonWithCommunityDetailInfo:)]) {
        [self.delegate communityIntroViewCell:self didClickVisitButtonWithCommunityDetailInfo:self.communityDetailInfo];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
