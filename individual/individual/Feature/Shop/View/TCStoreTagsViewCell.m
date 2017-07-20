//
//  TCStoreTagsViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreTagsViewCell.h"
#import "TCStoreTagView.h"

@interface TCStoreTagsViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *tagViews;

@end

@implementation TCStoreTagsViewCell

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"相关标签";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(20);
    }];
}

- (void)setSellingPoint:(NSArray *)sellingPoint {
    _sellingPoint = sellingPoint;
    
    for (TCStoreTagView *tagView in self.tagViews) {
        [tagView removeFromSuperview];
    }
    [self.tagViews removeAllObjects];
    
    TCStoreTagView *lastView = nil;
    CGFloat maxWidth = 0;
    CGFloat padding = 20, margin = 10;
    CGSize currentSize = CGSizeZero;
    for (int i=0; i<sellingPoint.count; i++) {
        NSString *title = sellingPoint[i];
        TCStoreTagView *tagView = [[TCStoreTagView alloc] init];
        tagView.titleLabel.text = title;
        [self.contentView addSubview:tagView];
        [self.tagViews addObject:tagView];
        
        if (lastView) {
            currentSize = [tagView intrinsicContentSize];
            NSLog(@"%@", NSStringFromCGSize(currentSize));
            maxWidth += (margin + currentSize.width);
            NSLog(@"%f", maxWidth);
            if (maxWidth + padding > TCScreenWidth) {
                [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(margin);
                    make.left.equalTo(self.contentView).offset(padding);
                }];
                maxWidth = padding + currentSize.width;
            } else {
                [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView);
                    make.left.equalTo(lastView.mas_right).offset(margin);
                }];
            }
        } else {
            [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
                make.left.equalTo(self.contentView).offset(padding);
            }];
            maxWidth = padding + [tagView intrinsicContentSize].width;
        }
        lastView = tagView;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-35);
    }];
}

- (NSMutableArray *)tagViews {
    if (_tagViews == nil) {
        _tagViews = [NSMutableArray array];
    }
    return _tagViews;
}

@end
