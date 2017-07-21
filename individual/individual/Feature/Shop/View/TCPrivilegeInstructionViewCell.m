//
//  TCPrivilegeInstructionViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeInstructionViewCell.h"

@interface TCPrivilegeInstructionViewCell ()

@property (weak, nonatomic) UILabel *instructionLabel;

@end

@implementation TCPrivilegeInstructionViewCell

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
    
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.textAlignment = NSTextAlignmentLeft;
    instructionLabel.numberOfLines = 0;
    [self.contentView addSubview:instructionLabel];
    self.instructionLabel = instructionLabel;
    
    [instructionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setInstructionStr:(NSString *)instructionStr {
    _instructionStr = instructionStr;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:instructionStr
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                              NSForegroundColorAttributeName: TCGrayColor,
                                                                              NSParagraphStyleAttributeName: paragraphStyle
                                                                              }];
    self.instructionLabel.attributedText = attStr;
}

@end
