//
//  TCProfileViewCell.m
//  individual
//
//  Created by 穆康 on 2017/8/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewCell.h"

#define defaultTag 777

@interface TCProfileViewCell ()

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation TCProfileViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat padding = 20;
    UIButton *lastButton = nil;
    for (int i=0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:TCBlackColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = defaultTag + i;
        [button addTarget:self action:@selector(handleClickFeatureButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            if (lastButton) {
                make.left.equalTo(lastButton.mas_right);
                make.width.equalTo(lastButton);
            } else {
                make.left.equalTo(self.contentView).offset(padding);
            }
        }];
        
        lastButton = button;
    }
    
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-padding);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    for (UIButton *button in self.buttons) {
        CGSize imageViewSize, labelSize;
        imageViewSize = button.imageView.size;
        labelSize = button.titleLabel.size;
        
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width, 0, 0);
    }
}

- (void)setMaterials:(NSArray *)materials {
    _materials = materials;
    
    for (int i=0; i<4; i++) {
        UIButton *button = self.buttons[i];
        NSDictionary *dic = materials[i];
        
        [button setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
        [button setTitle:dic[@"title"] forState:UIControlStateNormal];
    }
}

- (void)handleClickFeatureButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(profileViewCell:didClickFeatureButtonWithIndex:)]) {
        NSInteger index = button.tag - defaultTag;
        [self.delegate profileViewCell:self didClickFeatureButtonWithIndex:index];
    }
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
