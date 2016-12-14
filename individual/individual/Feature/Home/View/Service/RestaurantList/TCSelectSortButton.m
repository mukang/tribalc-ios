//
//  TCSelectSortButton.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectSortButton.h"

@implementation TCSelectSortButton {
    NSString *imageName;
}

- (instancetype)initWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndText:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        imageName = imgName;
        
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, TCRealValue(24), frame.size.width, 0)];
        UIImage *img = [UIImage imageNamed:imgName];
        [_imgBtn setHeight:30];
        _imgBtn.userInteractionEnabled = NO;
        [_imgBtn setImage:img forState:UIControlStateNormal];
        
        _textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgBtn.y + _imgBtn.height + TCRealValue(11), self.width, TCRealValue(12))];
        _textLab.text = text;
        _textLab.font = [UIFont systemFontOfSize:TCRealValue(14)];
        _textLab.textAlignment = NSTextAlignmentCenter;
        
        [self addTarget:self action:@selector(touchSortButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:_imgBtn];
        [self addSubview:_textLab];
    }
    
    return self;
}

- (void)touchSortButton {
    
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_high", imageName]];
    [_imgBtn setImage:img forState:UIControlStateNormal];
    
    _textLab.textColor = [UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
