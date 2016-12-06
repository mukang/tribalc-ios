//
//  TCCommonInputViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonInputViewCell.h"

@interface TCCommonInputViewCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation TCCommonInputViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.delegate = self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    
    self.textField.text = content;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                              NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                              }];
    self.textField.attributedPlaceholder = attStr;
}

- (void)setInputEnabled:(BOOL)inputEnabled {
    _inputEnabled = inputEnabled;
    
    if (inputEnabled) {
        self.textField.enabled = YES;
        if (self.tapGesture) {
            [self.containerView removeGestureRecognizer:self.tapGesture];
            self.tapGesture = nil;
        }
    } else {
        self.textField.enabled = NO;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContainerViewGesture:)];
        [self.containerView addGestureRecognizer:tapGesture];
        self.tapGesture = tapGesture;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(commonInputViewCell:textFieldDidEndEditing:)]) {
        [self.delegate commonInputViewCell:self textFieldDidEndEditing:self.textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(commonInputViewCell:textFieldShouldReturn:)]) {
        return [self.delegate commonInputViewCell:self textFieldShouldReturn:self.textField];
    } else {
        return YES;
    }
}

- (void)handleTapContainerViewGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapContainerViewIncommonInputViewCell:)]) {
        [self.delegate didTapContainerViewIncommonInputViewCell:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[textField textInputMode] primaryLanguage] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end