//
//  TCTabBar.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

NSString *const TCVicinityButtonDidClickNotification = @"TCVicinityButtonDidClickNotification";

#import "TCTabBar.h"

@interface TCTabBar ()

@property (weak, nonatomic) UIButton *vicinityButton;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

/*
 {
 NSColor = "UIExtendedSRGBColorSpace 0.262745 0.262745 0.262745 1";
 NSFont = "<UICTFont: 0x7fc5c770a610> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 10.00pt";
 NSParagraphStyle = "Alignment 4, LineSpacing 0, ParagraphSpacing 0, ParagraphSpacingBefore 0, HeadIndent 0, TailIndent 0, FirstLineHeadIndent 0, LineHeight 0/0, LineHeightMultiple 0, LineBreakMode 4, Tabs (\n    28L,\n    56L,\n    84L,\n    112L,\n    140L,\n    168L,\n    196L,\n    224L,\n    252L,\n    280L,\n    308L,\n    336L\n), DefaultTabInterval 0, Blocks (\n), Lists (\n), BaseWritingDirection -1, HyphenationFactor 0, TighteningForTruncation NO, HeaderLevel 0";
 NSShadow = "NSShadow {0, -1} color = {(null)}";
 }
 */

- (void)setupSubviews {
    self.translucent = NO;
    
    UIButton *vicinityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vicinityButton setBackgroundImage:[UIImage imageNamed:@"tabBar_vicinity"] forState:UIControlStateNormal];
    [vicinityButton addTarget:self action:@selector(handleClickVicinityButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:vicinityButton];
    self.vicinityButton = vicinityButton;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"附近";
    titleLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.textColor = TCRGBColor(112, 112, 112);
    [titleLabel sizeToFit];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = self.width / 5.0;
    CGFloat buttonH = self.height;
    int buttonIndex = 0;
    
    for (UIView *childView in self.subviews) {
        if ([childView isKindOfClass:[UIControl class]] && ![childView isKindOfClass:[UIButton class]]) {
            CGFloat buttonX = buttonW * buttonIndex;
            childView.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
            buttonIndex ++;
            if (buttonIndex == 2) {
                buttonIndex ++;
            }
        }
    }
    CGFloat margin = 10;
    self.vicinityButton.size = self.vicinityButton.currentBackgroundImage.size;
    self.vicinityButton.center = CGPointMake(self.width * 0.5, self.height * 0.5 - 15.6);
    self.titleLabel.center = CGPointMake(self.width * 0.5, CGRectGetMaxY(self.vicinityButton.frame) + margin);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isHidden) {
        CGPoint newPoint = [self convertPoint:point toView:self.vicinityButton];
        if ([self.vicinityButton pointInside:newPoint withEvent:event]) {
            return self.vicinityButton;
        } else {
            return [super hitTest:point withEvent:event];
        }
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)handleClickVicinityButton:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:TCVicinityButtonDidClickNotification object:nil];
}

@end
