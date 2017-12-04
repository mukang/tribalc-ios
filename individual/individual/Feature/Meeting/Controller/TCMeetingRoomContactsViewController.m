//
//  TCMeetingRoomContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsViewController.h"
#import "TCMeetingRoomAddContactsViewController.h"
#import "TCMeetingRoomAddAttendeeViewController.h"
#import "TCNavigationController.h"

#import "TCMeetingRoomNoParticipantView.h"
#import "TCMeetingRoomContactsViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <PPGetAddressBook/PPGetAddressBook.h>

@interface TCMeetingRoomContactsViewController () <UITableViewDataSource, UITableViewDelegate, TCMeetingRoomAddContactsViewControllerDelegate, MGSwipeTableCellDelegate>

@property (weak, nonatomic) TCMeetingRoomNoParticipantView *noParticipantView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCommonButton *button;

@property (weak, nonatomic) TCNavigationController *nav;
@property (nonatomic) BOOL originInteractivePopGestureEnabled;

@end

@implementation TCMeetingRoomContactsViewController

- (instancetype)initWithControllerType:(TCMeetingRoomContactsViewControllerType)controllerType {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _controllerType = controllerType;
        _participants = [NSMutableArray array];
        //请求用户获取通讯录权限
        [PPGetAddressBook requestAddressBookAuthorization];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"参会人";
    self.view.backgroundColor = TCBackgroundColor;
    
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomContactsViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CGFloat buttonH = 0;
    if (self.controllerType == TCMeetingRoomContactsViewControllerTypeAdd) {
        buttonH = 49;
        TCMeetingRoomNoParticipantView *noParticipantView = [[TCMeetingRoomNoParticipantView alloc] init];
        [self.view addSubview:noParticipantView];
        self.noParticipantView = noParticipantView;
        
        UIButton *directlyAddButton = [self creatButtonWithTitle:@"直接添加"
                                                     normalImage:[UIImage imageWithColor:TCRGBColor(151, 171, 234)]
                                                highlightedImage:[UIImage imageWithColor:TCRGBColor(125, 151, 234)]];
        [directlyAddButton addTarget:self action:@selector(handleClickDirectlyAddButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:directlyAddButton];
        
        UIButton *addressBookButton = [self creatButtonWithTitle:@"通讯录导入"
                                                     normalImage:[UIImage imageWithColor:TCRGBColor(113, 130, 220)]
                                                highlightedImage:[UIImage imageWithColor:TCRGBColor(90, 111, 220)]];
        [addressBookButton addTarget:self action:@selector(handleClickAddressBookButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addressBookButton];
        
        [noParticipantView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(directlyAddButton.mas_top);
        }];
        [directlyAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(buttonH);
            make.bottom.left.equalTo(self.view);
            make.right.equalTo(addressBookButton.mas_left);
        }];
        [addressBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(directlyAddButton);
            make.bottom.right.equalTo(self.view);
        }];
        
        if (self.participants.count) {
            noParticipantView.hidden = YES;
            tableView.hidden = NO;
        } else {
            noParticipantView.hidden = NO;
            tableView.hidden = YES;
        }
    }
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-buttonH);
    }];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.participants.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomContactsViewCell" forIndexPath:indexPath];
    TCMeetingParticipant *participant = self.participants[indexPath.row];
    cell.participant = participant;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TCMeetingRoomAddContactsViewControllerDelegate

- (void)meetingRoomAddContactsViewController:(TCMeetingRoomAddContactsViewController *)vc didClickSaveButtonWithSelectedParticipantDict:(NSMutableDictionary *)selectedParticipantDict {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *key in selectedParticipantDict.allKeys) {
        [tempArray addObject:selectedParticipantDict[key]];
    }
    if (tempArray.count) {
        self.noParticipantView.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.noParticipantView.hidden = NO;
        self.tableView.hidden = YES;
    }
    self.participants = tempArray;
    [self.tableView reloadData];
}

#pragma mark - MGSwipeTableCellDelegate

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction fromPoint:(CGPoint)point {
    if (self.controllerType == TCMeetingRoomContactsViewControllerTypeAdd) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)swipeTableCell:(TCMeetingRoomContactsViewCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.participants removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    return YES;
}

#pragma mark - Actions

- (void)handleClickDirectlyAddButton {
    __weak typeof(self) weakSelf = self;
    TCMeetingRoomAddAttendeeViewController *vc = [[TCMeetingRoomAddAttendeeViewController alloc] init];
    vc.addAttendeeblock = ^(TCMeetingParticipant *participant) {
        weakSelf.noParticipantView.hidden = YES;
        weakSelf.tableView.hidden = NO;
        int index = -1;
        for (int i=0; i<weakSelf.participants.count; i++) {
            TCMeetingParticipant *temp = weakSelf.participants[i];
            if ([participant.phone isEqualToString:temp.phone]) {
                index = i;
                break;
            }
        }
        if (index >= 0) {
            [weakSelf.participants replaceObjectAtIndex:index withObject:participant];
        } else {
            [weakSelf.participants addObject:participant];
        }
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickAddressBookButton {
    TCMeetingRoomAddContactsViewController *vc = [[TCMeetingRoomAddContactsViewController alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.participants.count];
    for (int i=0; i<self.participants.count; i++) {
        TCMeetingParticipant *participant = self.participants[i];
        [dict setObject:participant forKey:participant.phone];
    }
    vc.selectedParticipantDict = dict;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
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
