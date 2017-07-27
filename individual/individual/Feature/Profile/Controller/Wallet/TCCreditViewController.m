//
//  TCCreditViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditViewController.h"
#import "TCCreditBillViewController.h"
#import "TCRepaymentViewController.h"

#import "TCWalletAccount.h"
#import <TCCommonLibs/TCCommonButton.h>

@interface TCCreditViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) UIBezierPath *trackPath;

@property (strong, nonatomic) UIBezierPath *progressPath;

@property (strong, nonatomic) CAShapeLayer *trackLayer;

@property (strong, nonatomic) CAShapeLayer *progressLayer;

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation TCCreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    [self setUpNav];
    [self createBezierPath:CGRectMake(0, 0, 150, 150)];

}

- (void)repay {
    TCRepaymentViewController *vc = [[TCRepaymentViewController alloc] init];
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

//画两个圆形
-(void)createBezierPath:(CGRect)mybound
{
    //外圆
    _trackPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TCScreenWidth/2, 100) radius:(mybound.size.width - 0.7)/ 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    _trackLayer = [CAShapeLayer new];
    [self.tableView.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = nil;
    _trackLayer.strokeColor=[UIColor grayColor].CGColor;
    _trackLayer.path = _trackPath.CGPath;
    _trackLayer.lineWidth=5;
    _trackLayer.frame = mybound;
    
    [self.tableView.layer addSublayer:self.gradientLayer];
    self.gradientLayer.frame = CGRectMake((TCScreenWidth-170)/2, (200-170)/2, 170, 170);
    
    //内圆
    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TCScreenWidth/2, 100) radius:(mybound.size.width - 0.7)/ 2 startAngle:M_PI_4 endAngle:(M_PI * 2) * (self.walletAccount.creditBalance/self.walletAccount.creditLimit) + M_PI_4 clockwise:YES];
//    _progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(TCScreenWidth/2, 100) radius:(mybound.size.width - 0.7)/ 2 startAngle:M_PI_2 endAngle:(M_PI * 2) * 0.6 + M_PI_2 clockwise:YES];
    
    _progressLayer = [CAShapeLayer new];
    //    [self.tableView.tableHeaderView.layer addSublayer:_progressLayer];
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor=TCRGBColor(129, 184, 238).CGColor;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.path = _progressPath.CGPath;
    _progressLayer.lineWidth=10;
    _progressLayer.frame = CGRectMake(-(TCScreenWidth-170)/2, -15, 150, 150);
    
    [UIView animateWithDuration:1.0 animations:^{
        self.gradientLayer.mask = _progressLayer;
    }];
}

#pragma mark UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCRGBColor(239, 245, 245);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = TCBlackColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = TCBlackColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"本期账单";
        cell.imageView.image = [UIImage imageNamed:@"currentBill"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.walletAccount.creditBalance];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"授信额度";
            cell.imageView.image = [UIImage imageNamed:@"creditLimit"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",self.walletAccount.creditLimit];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"账单日";
            cell.imageView.image = [UIImage imageNamed:@"billDay"];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.walletAccount.billDay]];
        }else {
            cell.textLabel.text = @"还款日";
            cell.imageView.image = [UIImage imageNamed:@"repaymentDay"];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.walletAccount.repayDay]];
        }
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)log {
    TCCreditBillViewController *billVC = [[TCCreditBillViewController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

- (void)setUpNav {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"历史账单" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


#pragma mark - Getter methods

- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        _gradientLayer             = [CAGradientLayer layer];
        // 设置颜色
        _gradientLayer.colors = @[(__bridge id)TCRGBColor(130, 207, 246).CGColor,
                                  
                                  (__bridge id)TCRGBColor(126, 152, 226).CGColor];
        // 设置颜色渐变方向
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        // 设置颜色分割点
        _gradientLayer.locations  = @[@(0.5), @(0.75)];
    }
    return _gradientLayer;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM/dd"];
    }
    return _dateFormatter;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableHeaderView = self.headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 8;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.rowHeight = 45;
        _tableView.backgroundColor = TCRGBColor(239, 245, 245);
        self.headerView.frame = CGRectMake(0, 0, TCScreenWidth, 208);
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 67)];
        _tableView.tableFooterView = footerView;
        TCCommonButton *repayBtn = [TCCommonButton buttonWithTitle:@"还  款" color:TCCommonButtonColorPurple target:self action:@selector(repay)];
        repayBtn.frame = CGRectMake(30, 27, TCScreenWidth-60, 40);
        [footerView addSubview:repayBtn];
    }
    return _tableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = TCRGBColor(239, 245, 245);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, TCScreenWidth, 200);
        imageView.image = [UIImage imageNamed:@"creditHeader"];
        [_headerView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((TCScreenWidth-100)/2, 60, 100, 20)];
        label.text = @"可用额度";
        label.textColor = TCBlackColor;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:label];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake((TCScreenWidth-140)/2, 85, 140, 30)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:27];
        [_headerView addSubview:_moneyLabel];
        
        NSString *str = [NSString stringWithFormat:@"¥%.2f",(self.walletAccount.creditLimit-self.walletAccount.creditBalance)];
        NSMutableAttributedString *mutableAtt = [[NSMutableAttributedString alloc] initWithString:str];
        [mutableAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
        [mutableAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str.length-2, 2)];
        _moneyLabel.attributedText = mutableAtt;
        
    }
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
