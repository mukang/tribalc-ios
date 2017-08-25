//
//  TCProfileViewCell.m
//  individual
//
//  Created by 穆康 on 2017/8/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewCell.h"
#import "TCProfileFeatureView.h"

#define defaultTag 777

@interface TCProfileViewCell ()

@property (strong, nonatomic) NSMutableArray *featureViews;

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
    TCProfileFeatureView *lastView = nil;
    for (int i=0; i<4; i++) {
        TCProfileFeatureView *featureView = [[TCProfileFeatureView alloc] init];
        featureView.button.tag = defaultTag + i;
        [featureView.button addTarget:self action:@selector(handleClickFeatureButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:featureView];
        [self.featureViews addObject:featureView];
        
        [featureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(lastView);
            } else {
                make.left.equalTo(self.contentView).offset(padding);
            }
        }];
        
        lastView = featureView;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-padding);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 10;
    for (TCProfileFeatureView *featureView in self.featureViews) {
        CGSize imageViewSize, labelSize;
        imageViewSize = featureView.button.imageView.size;
        labelSize = featureView.button.titleLabel.size;
        
        featureView.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width);
        featureView.button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width, 0, 0);
    }
}

- (void)setUnReadNumDic:(NSDictionary *)unReadNumDic {
    if ([unReadNumDic isKindOfClass:[NSDictionary class]]) {
        _unReadNumDic = unReadNumDic;
        
        NSDictionary *dic = unReadNumDic[@"messageTypeCount"];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSNumber *num = dic[@"ORDER_DELIVERY"];
            if ([num isKindOfClass:[NSNumber class]]) {
                TCProfileFeatureView *featureView = self.featureViews[2];
                featureView.unReadNum = num;
            }
        }
    }
}

- (void)setMaterials:(NSArray *)materials {
    _materials = materials;
    
    for (int i=0; i<4; i++) {
        TCProfileFeatureView *featureView = self.featureViews[i];
        if (i < materials.count) {
            featureView.hidden = NO;
            NSDictionary *dic = materials[i];
            
            [featureView.button setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
            [featureView.button setTitle:dic[@"title"] forState:UIControlStateNormal];
        } else {
            featureView.hidden = YES;
        }
    }
}

- (void)handleClickFeatureButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(profileViewCell:didClickFeatureButtonWithIndex:)]) {
        NSInteger index = button.tag - defaultTag;
        [self.delegate profileViewCell:self didClickFeatureButtonWithIndex:index];
    }
}

- (NSMutableArray *)featureViews {
    if (_featureViews == nil) {
        _featureViews = [NSMutableArray array];
    }
    return _featureViews;
}

@end
