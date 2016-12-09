//
//  TCUserReserveDetailViewController.m
//  individual
//
//  Created by WYH on 16/12/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserReserveDetailViewController.h"
#import "TCComponent.h"
#import "TCGetNavigationItem.h"
#import "TCImageURLSynthesizer.h"
#import "TCUserReserveTableViewCell.h"
#import "TCBuluoApi.h"

@interface TCUserReserveDetailViewController () {
//    UITableView *reserveDetailTableView;
//    NSDictionary *reserveDetailDic;
    NSString *mReservationId;
    TCReservationDetail *reservationDetail;
}

@end

@implementation TCUserReserveDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.view.backgroundColor = [UIColor whiteColor];

}

- (instancetype)initWithReservationId:(NSString *)reservationId {
    self = [super init];
    if (self) {
        mReservationId = reservationId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    
    [self initReservationDetail];
}


- (void)initReservationDetail {
    [[TCBuluoApi api] fetchReservationDetail:mReservationId result:^(TCReservationDetail *reservation, NSError *error) {
        reservationDetail = reservation;
        [self initUI];
    }];
}


- (void)initUI {
    UIScrollView *mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mScrollView.backgroundColor = TCRGBColor(242, 242, 242);
    [self.view addSubview:mScrollView];
    
    
    UIView *statusView = [self getStatusViewWithStatus:@"订座处理中"];
    [mScrollView addSubview:statusView];
    
    UITableView *mTableView = [self getReserveDetailTableView];
    [mScrollView addSubview:mTableView];
    
    UIView *customerView = [self getContactCustomerServiceViewWithFrame:CGRectMake(0, mTableView.y + mTableView.height, self.view.width, 44)];
    [mScrollView addSubview:customerView];
    
    UIButton *cancelBtn =[self getCancelOrderBtnWithFrame:CGRectMake(self.view.width / 2 - 315 / 2, customerView.y + customerView.height, 315, 40)];
    [mScrollView addSubview:cancelBtn];

}

- (void)initNavigationBar {
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self  action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"我的预订"];
}


- (UITableView *)getReserveDetailTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 71, self.view.width, 131 + 11 * 2 + 66 + 40 * 5) style:UITableViewStylePlain];
    tableView.userInteractionEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (UIButton *)getCancelOrderBtnWithFrame:(CGRect)frame {
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:frame];
    cancelBtn.backgroundColor = TCRGBColor(81, 199, 209);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelBtn.layer.cornerRadius = 5;
    
    return cancelBtn;
}

- (UIView *)getContactCustomerServiceViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *tagLab = [TCComponent createLabelWithText:@"有问题请联系客服 : " AndFontSize:12];
    tagLab.textColor = TCRGBColor(154, 154, 154);
    UIButton *phoneBtn = [[UIButton alloc] init];
    [phoneBtn setTitle:@"4008-252-987" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [phoneBtn sizeToFit];
    
    tagLab.frame = CGRectMake(self.view.width / 2 - (tagLab.width + phoneBtn.width) / 2, 0, tagLab.width, view.height);
    phoneBtn.frame = CGRectMake(tagLab.x + tagLab.width, 0, phoneBtn.width, view.height);
    [view addSubview:tagLab];
    [view addSubview:phoneBtn];
    
    return view;
}


- (UIView *)getStatusViewWithStatus:(NSString *)status {
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 71)];
    statusView.backgroundColor = TCRGBColor(242, 242, 242);
    UILabel *statusLab = [TCComponent createLabelWithText:status AndFontSize:14];
    statusLab.frame = CGRectMake(self.view.width / 2 - (statusLab.width + 17) / 2, 20, statusLab.width, 14);
    [statusView addSubview:statusLab];
    
    UIImageView *statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(statusLab.x - 17, statusLab.y, 14, 14)];
    statusImgView.image = [UIImage imageNamed:[self getStatusImgName:status]];
    [statusView addSubview:statusImgView];
    
    UILabel *statusPromptLab = [TCComponent createLabelWithFrame:CGRectMake(0, statusView.height - 15 - 12, self.view.width, 12) AndFontSize:12 AndTitle:[self getStatusPrompt:status] AndTextColor:TCRGBColor(125, 125, 125)];
    statusPromptLab.textAlignment = NSTextAlignmentCenter;
    [statusView addSubview:statusPromptLab];
    
    
    return statusView;
}

- (NSString *)getStatusPrompt:(NSString *)statusStr {
    if ([statusStr isEqualToString:@"订座处理中"]) {
        return @"预计在5分钟内通过短信告知您的订单结果";
    } else if ([statusStr isEqualToString:@"订座完成"]) {
        return @"恭喜您的订座已完成 请您按时间到达☺";
    } else {
        return @"订餐未能按指定要求安排座位";
    }
}

- (NSString *)getStatusImgName:(NSString *)statusStr {
    if ([statusStr isEqualToString:@"订座处理中"]) {
        return @"reserve_handle";
    } else if ([statusStr isEqualToString:@"订座完成"]) {
        return @"reserve_complete";
    } else {
        return @"reserve_fail";
    }
}


- (UITableViewCell *)getTableViewCellForReserveDetail {
    TCUserReserveTableViewCell *cell = [[TCUserReserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [UIColor whiteColor];
    cell.storeImageView.frame = CGRectMake(cell.storeImageView.x + 8, 131 / 2 - 109.5 / 2, cell.storeImageView.width - 8, 109.5);
    [cell.storeImageView sd_setImageWithURL:[TCImageURLSynthesizer synthesizeImageURLWithPath:reservationDetail.mainPicture] placeholderImage:[UIImage imageNamed:@"good_placeholder"]];
    cell.timeLab.text = @"2016";
    cell.personNumberLab.text = [NSString stringWithFormat:@"%li", (long)reservationDetail.personNum];
    [cell setTitleLabText:reservationDetail.storeName];
    [cell setBrandLabText:@"西餐"];
    [cell setPlaceLabText:reservationDetail.markPlace];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    [cell addSubview:topLineView];
    UIView *bottomView = [self getTableBottomViewWithFrame:CGRectMake(0, 131, self.view.width, 11)];
    [cell addSubview:bottomView];
    
    return cell;
}

- (UITableViewCell *)getTableViewCellForBaseInfo:(NSDictionary *)infoDic {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [TCComponent createLabelWithText:infoDic[@"title"] AndFontSize:12];
    titleLab.frame = CGRectMake(20, 0, titleLab.width, 40);
    [cell addSubview:titleLab];
    
    UILabel *detailLab = [TCComponent createLabelWithText:infoDic[@"detail"] AndFontSize:12];
    detailLab.frame = CGRectMake(titleLab.x + titleLab.width + 20, 0, self.view.width - titleLab.x - titleLab.width - 40, 40);
    detailLab.textAlignment = NSTextAlignmentRight;
    [cell addSubview:detailLab];
    
    UIView *bottomLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 40 - 0.5, self.view.width - 40, 0.5)];
    [cell addSubview:bottomLineView];
    if ([infoDic[@"title"] isEqualToString:@"联系电话"]) {
        bottomLineView.frame = CGRectMake(0, 40 - 0.5, self.view.width, 0.5);
    }
    
    return cell;
}

- (UITableViewCell *)getTableViewCellForAddressInfo:(NSDictionary *)infoDic {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 13, 25, 12) AndFontSize:12 AndTitle:infoDic[@"title"]];
    [cell addSubview:titleLab];
    UILabel *addressLab = [self getAddressLabelWithText:infoDic[@"detail"]];
    [cell addSubview:addressLab];
    
    UIView *bottomView = [self getTableBottomViewWithFrame:CGRectMake(0, 66, self.view.width, 11)];
    [cell addSubview:bottomView];
    
    return cell;
}

- (UILabel *)getAddressLabelWithText:(NSString *)text {
    UILabel *addressLab = [[UILabel alloc] initWithFrame:CGRectMake(20 + 28 + 25, 10, self.view.width - 45 - 28 - 20, 40)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 9;
    NSRange range = NSMakeRange(0, text.length);
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    addressLab.numberOfLines = 2;
    addressLab.lineBreakMode = NSLineBreakByWordWrapping;
    addressLab.font = [UIFont systemFontOfSize:12];
    addressLab.attributedText = attrStr;
    
    return addressLab;
}

- (NSArray *)getReserveArray {
    NSString *personNumStr = [NSString stringWithFormat:@"%li", (long)reservationDetail.personNum];
    NSString *addressStr = reservationDetail.address ? reservationDetail.address : @"";
    NSDictionary *timeDic = @{ @"title":@"时间", @"detail":@"2014" };
    NSDictionary *numberDic = @{ @"title":@"人数", @"detail":personNumStr };
    NSDictionary *resDic = @{ @"title":@"餐厅", @"detail":reservationDetail.storeName };
    NSDictionary *addressDic = @{ @"title":@"地点", @"detail":addressStr };
    NSDictionary *contactsDic = @{ @"title":@"联系人", @"detail": reservationDetail.linkman};
    NSDictionary *phoneDic = @{ @"title":@"联系电话", @"detail":reservationDetail.phone };
    return @[timeDic, numberDic, resDic, addressDic, contactsDic, phoneDic];
}

- (UIView *)getTableBottomViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = TCRGBColor(242, 242, 242);
    UIView *bottomLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, view.height - 0.5, view.width, 0.5)];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, view.width, 0.5)];
    [view addSubview:bottomLineView];
    [view addSubview:topLineView];
    
    return view;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self getTableViewCellForReserveDetail];
    } else {
        NSArray *reserveDetailArr = [self getReserveArray];
        if (indexPath.row != 4) {
            return [self getTableViewCellForBaseInfo:reserveDetailArr[indexPath.row - 1]];
        } else {
            return [self getTableViewCellForAddressInfo:reserveDetailArr[indexPath.row - 1]];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 131 + 11;
    } else if (indexPath.row == 4) {
        return 66 + 11;
    } else {
        return 40;
    }
}

- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//- (void)forgeData {
//    reserveDetailDic = @{
//                         @"imgName":@"good_placeholder",
//                         @"title":@"FNRON",
//                         @"brand":@"西餐",
//                         @"place":@"安定门",
//                         @"time":@"2016-11-12  16:50",
//                         @"personNumber":@2,
//                         @"resName":@"DHUEHFAU(798店)",
//                         @"address":@"北京市朝阳区酒仙桥4号的家哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈等我打我对哇的哈哈哈哈哈哈哈哈哈",
//                         @"person":@"蓝天",
//                         @"phone":@"15678909823"
//                         };
//}

@end
