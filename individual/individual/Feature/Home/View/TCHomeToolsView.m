//
//  TCHomeToolsView.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeToolsView.h"

#define defaultTag 10000

@interface TCHomeToolsView ()

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation TCHomeToolsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(151, 171, 234);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.buttons = [NSMutableArray array];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *scanButton = [self createButtonWithTitle:@"扫一扫" imageName:@"home_scan_button_big"];
    scanButton.tag = defaultTag + 1;
    [containerView addSubview:scanButton];
    
    UIButton *unlockButton = [self createButtonWithTitle:@"开锁" imageName:@"home_unlocking_button_big"];
    unlockButton.tag = defaultTag + 2;
    [containerView addSubview:unlockButton];
    
    UIButton *maintainButton = [self createButtonWithTitle:@"报修" imageName:@"home_maintain_button_big"];
    maintainButton.tag = defaultTag + 3;
    [containerView addSubview:maintainButton];
    
    UIButton *meetingButton = [self createButtonWithTitle:@"会议室" imageName:@"home_meeting_button_big"];
    meetingButton.tag = defaultTag + 4;
    [containerView addSubview:meetingButton];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(containerView);
    }];
    [unlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(containerView);
        make.left.equalTo(scanButton.mas_right);
        make.width.equalTo(scanButton);
    }];
    [maintainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(containerView);
        make.left.equalTo(unlockButton.mas_right);
        make.width.equalTo(scanButton);
    }];
    [meetingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(containerView);
        make.left.equalTo(maintainButton.mas_right);
        make.width.equalTo(scanButton);
    }];
}

- (UIButton *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 15;
    for (UIButton *button in self.buttons) {
        CGSize imageViewSize, labelSize;
        imageViewSize = button.imageView.size;
        labelSize = button.titleLabel.size;
//        NSLog(@"%@ -- %@", NSStringFromCGSize(imageViewSize), NSStringFromCGSize(labelSize));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width, 0, 0);
    }
}

- (void)handleClickButton:(UIButton *)sender {
    NSInteger tag = sender.tag - defaultTag;
    switch (tag) {
        case 1:
            if ([self.delegate respondsToSelector:@selector(didClickScanButtonInHomeToolsView:)]) {
                [self.delegate didClickScanButtonInHomeToolsView:self];
            }
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(didClickUnlockButtonInHomeToolsView:)]) {
                [self.delegate didClickUnlockButtonInHomeToolsView:self];
            }
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(didClickMaintainButtonInHomeToolsView:)]) {
                [self.delegate didClickMaintainButtonInHomeToolsView:self];
            }
            break;
        case 4:
            if ([self.delegate respondsToSelector:@selector(didClickMeetingButtonInHomeToolsView:)]) {
                [self.delegate didClickMeetingButtonInHomeToolsView:self];
            }
            break;
            
        default:
            break;
    }
}

@end
