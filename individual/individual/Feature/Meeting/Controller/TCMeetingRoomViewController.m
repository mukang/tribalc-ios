//
//  TCMeetingRoomViewController.m
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomViewController.h"

#import "TCMeetingRoomSelectViewCell.h"
#import "TCMeetingRoomSupportedViewCell.h"
#import "TCMeetingRoomInfoViewCell.h"
#import "TCMeetingRoomTitleViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <UITableView+FDTemplateLayoutCell.h>

@interface TCMeetingRoomViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *headerView;
@property (weak, nonatomic) TCCommonButton *nextButton;

@end

@implementation TCMeetingRoomViewController {
    __weak TCMeetingRoomViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"会议室预定";
    
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomTitleViewCell class] forCellReuseIdentifier:@"TCMeetingRoomTitleViewCell"];
    [tableView registerClass:[TCMeetingRoomSelectViewCell class] forCellReuseIdentifier:@"TCMeetingRoomSelectViewCell"];
    [tableView registerClass:[TCMeetingRoomSupportedViewCell class] forCellReuseIdentifier:@"TCMeetingRoomSupportedViewCell"];
    [tableView registerClass:[TCMeetingRoomInfoViewCell class] forCellReuseIdentifier:@"TCMeetingRoomInfoViewCell"];
    [self.view addSubview:tableView];
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.frame = CGRectMake(0, 0, TCScreenWidth, TCRealValue(215));
    tableView.tableHeaderView = headerView;
    
    UILabel *footerView = [[UILabel alloc] init];
    footerView.text = @"您可在会议开始30分钟前取消订单";
    footerView.textColor = TCGrayColor;
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.font = [UIFont systemFontOfSize:14];
    footerView.frame = CGRectMake(0, 0, TCScreenWidth, 80);
    tableView.tableFooterView = footerView;
    
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:@"下一步"
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickNextButton)];
    [self.view addSubview:nextButton];
    
    self.tableView = tableView;
    self.headerView = headerView;
    self.nextButton = nextButton;
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.nextButton.mas_top);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell = nil;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        switch (row) {
            case 0:
            {
                TCMeetingRoomTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomTitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"星光时代UDC 会议室1";
                currentCell = cell;
            }
                break;
            case 1:
            {
                TCMeetingRoomSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSelectViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"预定日期";
                cell.subTitleLabel.text = @"请选择";
                currentCell = cell;
            }
                break;
            case 2:
            {
                TCMeetingRoomSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSelectViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"预定时间";
                cell.subTitleLabel.text = @"请选择";
                currentCell = cell;
            }
                break;
            case 3:
            {
                TCMeetingRoomSupportedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSupportedViewCell" forIndexPath:indexPath];
                cell.timeLabel.text = @"9:00-20:00 开放";
                cell.numLabel.text = @"可容纳6-8人";
                NSString *str = @"投影仪  窗户  矿泉水  白板  桌子  椅子  纸笔  柠檬茶  玫瑰花  无线网络";
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 6;
                NSAttributedString *attText = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                                                          NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                                          NSParagraphStyleAttributeName: paragraphStyle
                                                                                                          }];
                cell.supportedLabel.attributedText = attText;
                currentCell = cell;
            }
                break;
            case 4:
            {
                TCMeetingRoomInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomInfoViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"预订人";
                cell.subTitleLabel.text = @"张小花 15898768976";
                currentCell = cell;
            }
                break;
                
            default:
                break;
        }
    } else if (section == 1) {
        TCMeetingRoomSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSelectViewCell" forIndexPath:indexPath];
        if (row == 0) {
            cell.titleLabel.text = @"参会人";
            cell.subTitleLabel.text = @"添加参会人";
        } else {
            cell.titleLabel.text = @"提醒";
            cell.subTitleLabel.text = @"添加提醒";
        }
        currentCell = cell;
    } else {
        TCMeetingRoomInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomInfoViewCell" forIndexPath:indexPath];
        if (section == 2) {
            cell.titleLabel.text = @"企业支付";
            cell.subTitleLabel.text = @"杭州部落公社科技有限公司";
        } else {
            cell.titleLabel.text = @"费用估计";
            cell.subTitleLabel.text = @"¥ 30";
        }
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"TCMeetingRoomSupportedViewCell" configuration:^(TCMeetingRoomSupportedViewCell *cell) {
            cell.timeLabel.text = @"9:00-20:00 开放";
            cell.numLabel.text = @"可容纳6-8人";
            NSString *str = @"投影仪  窗户  矿泉水  白板  桌子  椅子  纸笔  柠檬茶  玫瑰花  无线网络";
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 6;
            NSAttributedString *attText = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                                      NSParagraphStyleAttributeName: paragraphStyle
                                                                                                      }];
            cell.supportedLabel.attributedText = attText;
        }];
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Actions

- (void)handleClickNextButton {
    
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
