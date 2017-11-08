//
//  TCMeetingRoomContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsViewController.h"
#import "TCMeetingRoomAddContactsViewController.h"
#import "TCNavigationController.h"

#import "TCMeetingRoomNoParticipantView.h"
#import "TCMeetingRoomContactsViewCell.h"
#import "TCMeetingRoomDeleteContactsViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>

typedef NS_ENUM(NSInteger, TCMeetingRoomContactsType) {
    TCMeetingRoomContactsTypeNormal = 0,
    TCMeetingRoomContactsTypeEditing
};

@interface TCMeetingRoomContactsViewController () <UITableViewDataSource, UITableViewDelegate, TCMeetingRoomAddContactsViewControllerDelegate, TCMeetingRoomDeleteContactsViewCellDelegate>

@property (weak, nonatomic) TCMeetingRoomNoParticipantView *noParticipantView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCommonButton *button;


@property (nonatomic) TCMeetingRoomContactsType type;

@property (weak, nonatomic) TCNavigationController *nav;
@property (nonatomic) BOOL originInteractivePopGestureEnabled;

@end

@implementation TCMeetingRoomContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"参会人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.type = TCMeetingRoomContactsTypeNormal;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    TCNavigationController *nav = (TCNavigationController *)self.navigationController;
    self.originInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
    nav.enableInteractivePopGesture = NO;
    self.nav = nav;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.nav.enableInteractivePopGesture = self.originInteractivePopGestureEnabled;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCMeetingRoomNoParticipantView *noParticipantView = [[TCMeetingRoomNoParticipantView alloc] init];
    [self.view addSubview:noParticipantView];
    self.noParticipantView = noParticipantView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomContactsViewCell"];
    [tableView registerClass:[TCMeetingRoomDeleteContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomDeleteContactsViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *button = [TCCommonButton buttonWithTitle:@"＋添加参会人"
                                                       color:TCCommonButtonColorPurple
                                                      target:self
                                                      action:@selector(handleClickButton)];
    [self.view addSubview:button];
    self.button = button;
    
    if (self.participants.count) {
        noParticipantView.hidden = YES;
        tableView.hidden = NO;
    } else {
        noParticipantView.hidden = NO;
        tableView.hidden = YES;
    }
    
    [noParticipantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(button.mas_top);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(button.mas_top);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.participants.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == TCMeetingRoomContactsTypeNormal) {
        TCMeetingRoomContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomContactsViewCell" forIndexPath:indexPath];
        TCMeetingParticipant *participant = self.participants[indexPath.section];
        cell.participant = participant;
        return cell;
    } else {
        TCMeetingRoomDeleteContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomDeleteContactsViewCell" forIndexPath:indexPath];
        TCMeetingParticipant *participant = self.participants[indexPath.section];
        cell.participant = participant;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TCMeetingRoomAddContactsViewControllerDelegate

- (void)meetingRoomAddContactsViewController:(TCMeetingRoomAddContactsViewController *)vc didClickSaveButtonWithParticipantArray:(NSArray *)participantArray {
    self.noParticipantView.hidden = YES;
    self.tableView.hidden = NO;
    for (TCMeetingParticipant *participant in participantArray) {
        participant.selected = NO;
    }
    [self.participants addObjectsFromArray:participantArray];
    [self.tableView reloadData];
    
    if (self.participants.count) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(handleClickItem)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                              forState:UIControlStateNormal];
    }
}

#pragma mark - TCMeetingRoomDeleteContactsViewCellDelegate

- (void)meetingRoomDeleteContactsViewCell:(TCMeetingRoomDeleteContactsViewCell *)cell didTapSelectedViewWithParticipant:(TCMeetingParticipant *)participant {
    participant.selected = !participant.isSelected;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleClickButton {
    if (self.type == TCMeetingRoomContactsTypeNormal) {
        TCMeetingRoomAddContactsViewController *vc = [[TCMeetingRoomAddContactsViewController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSMutableArray *temp = [NSMutableArray array];
        for (TCMeetingParticipant *participant in self.participants) {
            if (participant.isSelected) {
                [temp addObject:participant];
            }
        }
        for (TCMeetingParticipant *participant in temp) {
            [self.participants removeObject:participant];
        }
        [self.tableView reloadData];
    }
}

- (void)handleClickItem {
    if (self.type == TCMeetingRoomContactsTypeNormal) {
        for (TCMeetingParticipant *participant in self.participants) {
            participant.selected = NO;
        }
        self.type = TCMeetingRoomContactsTypeEditing;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(handleClickItem)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                              forState:UIControlStateNormal];
        NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"删  除"
                                                                       attributes:@{
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                    }];
        [self.button setAttributedTitle:attTitle forState:UIControlStateNormal];
        [self.tableView reloadData];
    } else {
        self.type = TCMeetingRoomContactsTypeNormal;
        if (self.participants.count) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(handleClickItem)];
            [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                                  forState:UIControlStateNormal];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
            self.noParticipantView.hidden = NO;
            self.tableView.hidden = YES;
        }
        NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"＋添加参会人"
                                                                       attributes:@{
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                    }];
        [self.button setAttributedTitle:attTitle forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    if (self.type == TCMeetingRoomContactsTypeEditing) {
        [MBProgressHUD showHUDWithMessage:@"请保存之后再退出"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInMeetingRoomContactsViewController:)]) {
        [self.delegate didClickBackButtonInMeetingRoomContactsViewController:self];
    }
    
    [super handleClickBackButton:sender];
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
