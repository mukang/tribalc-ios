//
//  TCLockQRCodeView.m
//  individual
//
//  Created by 穆康 on 2017/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLockQRCodeView.h"

static NSString *QRCodeGenerator = @"QRCodeGenerator";
static NSString *InputMessage = @"InputMessage";

@implementation TCLockQRCodeView {
    __weak TCLockQRCodeView *weakSelf;
}

- (instancetype)initWithLockQRCodeType:(TCLockQRCodeType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        weakSelf = self;
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 7.5;
        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *codeImageView = [[UIImageView alloc] init];
//    codeImageView.backgroundColor = [UIColor orangeColor];
    codeImageView.image = [self generateQRCodeImageWithCodeString:@"dai76dbsi9shehid9" size:CGSizeMake(TCRealValue(180), TCRealValue(180))];
    [self addSubview:codeImageView];
    
    if (self.type == TCLockQRCodeTypeOneself) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"设备名称：一楼主门锁";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = TCRGBColor(42, 42, 42);
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TCRGBColor(221, 221, 221);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset(TCRealValue(50));
            make.height.mas_equalTo(0.5);
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf).offset(10);
            make.trailing.equalTo(weakSelf).offset(-10);
            make.top.equalTo(weakSelf);
            make.bottom.equalTo(lineView.mas_top);
        }];
        [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(180), TCRealValue(180)));
            make.top.equalTo(lineView.mas_bottom).offset(TCRealValue(36));
            make.centerX.equalTo(weakSelf);
        }];
    } else {
        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.text = @"分享";
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = TCRGBColor(154, 154, 154);
        shareLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:shareLabel];
        
        UIView *leftlineView = [[UIView alloc] init];
        leftlineView.backgroundColor = TCRGBColor(221, 221, 221);
        [self addSubview:leftlineView];
        
        UIView *rightlineView = [[UIView alloc] init];
        rightlineView.backgroundColor = TCRGBColor(221, 221, 221);
        [self addSubview:rightlineView];
        
        UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatButton setImage:[UIImage imageNamed:@"lock_QR_code_wechat"] forState:UIControlStateNormal];
        [self addSubview:wechatButton];
        
        UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageButton setImage:[UIImage imageNamed:@"lock_QR_code_MMS"] forState:UIControlStateNormal];
        [self addSubview:messageButton];
        
        [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(180), TCRealValue(180)));
            make.top.equalTo(weakSelf).offset(TCRealValue(36));
            make.centerX.equalTo(weakSelf);
        }];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(codeImageView.mas_bottom).offset(TCRealValue(36));
            make.centerX.equalTo(weakSelf);
        }];
        [leftlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(63), 1));
            make.centerY.equalTo(shareLabel);
            make.trailing.equalTo(shareLabel.mas_leading).offset(-6);
        }];
        [rightlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(63), 1));
            make.centerY.equalTo(shareLabel);
            make.leading.equalTo(shareLabel.mas_trailing).offset(6);
        }];
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(37), TCRealValue(37)));
            make.centerX.equalTo(weakSelf.mas_centerX).offset(TCRealValue(-35));
            make.top.equalTo(leftlineView.mas_bottom).offset(TCRealValue(12));
        }];
        [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(wechatButton);
            make.top.equalTo(wechatButton);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(TCRealValue(35));
        }];
    }
}

#pragma mark - Generate QRCode

- (UIImage *)generateQRCodeImageWithCodeString:(NSString *)codeString size:(CGSize)size {
    if (codeString.length) {
        NSData *data = [codeString dataUsingEncoding:NSUTF8StringEncoding];
        
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        CIImage *outputImage = filter.outputImage;
        
        CGFloat scale = size.width / CGRectGetWidth(outputImage.extent);
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        CIImage *transformImage = [outputImage imageByApplyingTransform:transform];
        
        return [UIImage imageWithCIImage:transformImage];
    } else {
        return nil;
    }
}

@end
