//
//  TCWalletBill.m
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBill.h"

@implementation TCWalletBill

- (void)setPayChannel:(NSString *)payChannel {
    _payChannel = payChannel;
    
    if ([payChannel isKindOfClass:[NSString class]]) {
        if ([payChannel isEqualToString:@"BALANCE"]) {
            _payChannelStr = @"余额";
        }else if ([payChannel isEqualToString:@"ALIPAY"]) {
            _payChannelStr = @"支付宝";
        }else if ([payChannel isEqualToString:@"WECHAT"]) {
            _payChannelStr = @"微信";
        }else if ([payChannel isEqualToString:@"BF_BANKCARD"]) {
            _payChannelStr = @"银行卡";
        }
    }
}

- (void)setTradingType:(NSString *)tradingType {
    _tradingType = tradingType;
    if ([tradingType isKindOfClass:[NSString class]]) {
        if ([tradingType isEqualToString:@"CREATED"]) {
            _tradingTypeStr = @"未付款";
        }else if ([tradingType isEqualToString:@"PAY"]) {
            _tradingTypeStr = @"付款";
        }else if ([tradingType isEqualToString:@"RECEIPT"]) {
            _tradingTypeStr = @"收款";
        }else if ([tradingType isEqualToString:@"RECHARGE"]) {
            _tradingTypeStr = @"充值";
        }else if ([tradingType isEqualToString:@"WITHDRAW"]) {
            _tradingTypeStr = @"提现";
        }else if ([tradingType isEqualToString:@"REFUND"]) {
            _tradingTypeStr = @"退款";
        }
    }
}

- (void)setCreateTime:(NSInteger)createTime {
    _createTime = createTime;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:(createTime / 1000)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday fromDate:createDate];
    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    _tradingTime = [NSString stringWithFormat:@"%zd-%02zd-%02zd %02zd:%02zd:%02zd", components.year, components.month, components.day, components.hour, components.minute, components.second];
    if (components.year == nowComponents.year) { // 今年
        if (components.month == nowComponents.month) { // 本月
            _monthDate = @"本月";
        } else {
            _monthDate = [NSString stringWithFormat:@"%zd月", components.month];
        }
    } else {
        _monthDate = [NSString stringWithFormat:@"%zd年%zd月", components.year, components.month];
    }
    
    if ([calendar isDateInToday:createDate]) { // 今天
        _weekday = @"今天";
        _detailTime = [NSString stringWithFormat:@"%02zd:%02zd", components.hour, components.minute];
    } else {
        _detailTime = [NSString stringWithFormat:@"%02zd-%02zd", components.month, components.day];
        switch (components.weekday) {
            case 1:
                _weekday = @"周日";
                break;
            case 2:
                _weekday = @"周一";
                break;
            case 3:
                _weekday = @"周二";
                break;
            case 4:
                _weekday = @"周三";
                break;
            case 5:
                _weekday = @"周四";
                break;
            case 6:
                _weekday = @"周五";
                break;
            case 7:
                _weekday = @"周六";
                break;
                
            default:
                _weekday = @"";
                break;
        }
    }
}

@end
