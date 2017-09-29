//
//  TCWalletBillDetailViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBillDetailViewController.h"

#import "TCWalletBillDetailHeaderView.h"
#import "TCWalletBillDetailViewCell.h"

#import "TCWalletBill.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCWalletBillDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TCWalletBillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"账单详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 8)];
    topView.backgroundColor = TCRGBColor(239, 245, 245);
    [self.view addSubview:topView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 25;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    TCWalletBillDetailHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TCWalletBillDetailHeaderView" owner:nil options:nil] lastObject];
    NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:self.walletBill.anotherId needTimestamp:NO];
    UIImage *placeholderImage = [UIImage imageNamed:@"profile_default_avatar_icon"];
    [headerView.iconImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    headerView.accountLabel.text = self.walletBill.displayName;
    headerView.statusLabel.text = self.walletBill.tradingTypeStr;
    headerView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.walletBill.amount];
    self.tableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"TCWalletBillDetailViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCWalletBillDetailViewCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 100)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 20, TCScreenWidth-30, 0.5)];
    lineView.backgroundColor = TCSeparatorLineColor;
    [footerView addSubview:lineView];
    
    TCWalletBillDetailViewCell *cell1 = [[UINib nibWithNibName:@"TCWalletBillDetailViewCell" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil].firstObject;
    cell1.frame = CGRectMake(0, 35, TCScreenWidth, 25);
    cell1.titleLabel.text = @"交易说明:";
    cell1.detailLabel.text = self.walletBill.title;
    [footerView addSubview:cell1];
    TCWalletBillDetailViewCell *cell2 = [[UINib nibWithNibName:@"TCWalletBillDetailViewCell" bundle:[NSBundle mainBundle]] instantiateWithOwner:nil options:nil].firstObject;
    cell2.frame = CGRectMake(0, 60, TCScreenWidth, 25);
    cell2.titleLabel.text = @"备注信息:";
    cell2.detailLabel.text = self.walletBill.note;
    [footerView addSubview:cell2];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Status Bar



#pragma makr - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCWalletBillDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCWalletBillDetailViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"交易编号:";
            cell.detailLabel.text = self.walletBill.ID;
            break;
        case 1:
            cell.titleLabel.text = @"付款方式:";
            cell.detailLabel.text = self.walletBill.payChannelStr;
            break;
        case 2:
            cell.titleLabel.text = @"交易时间:";
            cell.detailLabel.text = self.walletBill.tradingTime;
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
