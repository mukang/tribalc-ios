//
//  TCRepairsDescViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsDescViewCell.h"

@interface TCRepairsDescViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TCRepairsDescViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textView.delegate = self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewShouldBeginEditingInRepairsDescViewCell:)]) {
        return [self.delegate textViewShouldBeginEditingInRepairsDescViewCell:self];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && [self.delegate respondsToSelector:@selector(repairsDescViewCell:textViewShouldReturn:)]) {
        return ![self.delegate repairsDescViewCell:self textViewShouldReturn:self.textView];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
