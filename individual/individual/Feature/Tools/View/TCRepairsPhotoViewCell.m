//
//  TCRepairsPhotoViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsPhotoViewCell.h"

@interface TCRepairsPhotoViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation TCRepairsPhotoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.layer.cornerRadius = 2.5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setHideAddButton:(BOOL)hideAddButton {
    _hideAddButton = hideAddButton;
    
    self.addButton.hidden = hideAddButton;
    self.containerView.hidden = !hideAddButton;
}

- (IBAction)handleClickAddButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAddButtonInRepairsPhotoViewCell:)]) {
        [self.delegate didClickAddButtonInRepairsPhotoViewCell:self];
    }
}

- (IBAction)handleClickDeleteButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickDeleteButtonInRepairsPhotoViewCell:)]) {
        [self.delegate didClickDeleteButtonInRepairsPhotoViewCell:self];
    }
}

@end
