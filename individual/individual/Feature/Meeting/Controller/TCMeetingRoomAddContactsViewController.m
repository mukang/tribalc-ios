//
//  TCMeetingRoomAddContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddContactsViewController.h"

#import "TCMeetingRoomAddContactsViewCell.h"
#import "TCMeetingRoomContactsTitleView.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/TCFunctions.h>
#import <PPGetAddressBook/PPGetAddressBook.h>

@interface TCMeetingRoomAddContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary<NSString *,NSArray *> *participantArrayDict;
@property (strong, nonatomic) NSMutableArray *nameKeyArray;
@property (strong, nonatomic) NSMutableDictionary *participantDict;

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCMeetingRoomAddContactsViewController {
    __weak TCMeetingRoomAddContactsViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"添加参会人";
    self.participantArrayDict = [NSMutableDictionary dictionary];
    self.nameKeyArray = [NSMutableArray array];
    self.participantDict = [NSMutableDictionary dictionary];
    
    [self setupSubviews];
    [self loadContacts];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomAddContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomAddContactsViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *saveButton = [TCCommonButton buttonWithTitle:@"保  存"
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickSaveButton)];
    [self.view addSubview:saveButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(saveButton.mas_top);
    }];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.left.right.equalTo(self.view);
    }];
}

- (void)loadContacts {
    [MBProgressHUD showHUD:YES];
    [weakSelf loadAddressBook];
    /*
    [[TCBuluoApi api] fetchMeetingRoomCommonContacts:^(NSArray *commonContacts, NSError *error) {
        if (commonContacts.count) {
            [weakSelf.participantArrayDict setObject:commonContacts forKey:@"*"];
            [weakSelf.nameKeyArray addObject:@"*"];
            for (TCMeetingParticipant *participant in commonContacts) {
                [weakSelf.participantDict setObject:participant forKey:participant.phone];
            }
        }
        [weakSelf loadAddressBook];
    }];
     */
}

- (void)loadAddressBook {
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf formatContactsWithAddressBookDict:addressBookDict nameKeys:nameKeys];
        });
    } authorizationFailure:^{
        [MBProgressHUD hideHUD:YES];
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                    message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许“嗨托邦”访问您的通讯录"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:action];
        [weakSelf presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)formatContactsWithAddressBookDict:(NSDictionary<NSString *,NSArray *> *)addressBookDict nameKeys:(NSArray *)nameKeys {
    [self.nameKeyArray addObjectsFromArray:nameKeys];
    for (int i=0; i<nameKeys.count; i++) {
        NSString *nameKey = nameKeys[i];
        NSArray *array = addressBookDict[nameKey];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:array.count];
        for (int j=0; j<array.count; j++) {
            PPPersonModel *personModel = array[j];
            NSString *name = personModel.name;
            for (int z=0; z<personModel.mobileArray.count; z++) {
                NSString *phone = personModel.mobileArray[z];
                if (!self.participantDict[phone]) {
                    TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
                    participant.name = name;
                    participant.phone = phone;
                    participant.selected = self.selectedParticipantDict[phone] ? YES : NO;
                    [self.participantDict setObject:participant forKey:phone];
                    [temp addObject:participant];
                }
            }
        }
        [self.participantArrayDict setObject:temp forKey:nameKey];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD:YES];
        [weakSelf.tableView reloadData];
    });
}

/*
- (NSString *)formatPhoneNum:(NSString *)originPhoneNum {
    originPhoneNum = [originPhoneNum stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    NSMutableCharacterSet *charSet = [[NSMutableCharacterSet alloc] init];
    [charSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [charSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    NSArray *arrayWithNumbers = [originPhoneNum componentsSeparatedByCharactersInSet:charSet];
    NSString *phoneNum = [arrayWithNumbers componentsJoinedByString:@""];
    
    return phoneNum;
}
 */

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.nameKeyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *nameKey = self.nameKeyArray[section];
    NSArray *array = self.participantArrayDict[nameKey];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomAddContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomAddContactsViewCell" forIndexPath:indexPath];
    NSString *nameKey = self.nameKeyArray[indexPath.section];
    NSArray *array = self.participantArrayDict[nameKey];
    TCMeetingParticipant *participant = array[indexPath.row];
    cell.participant = participant;
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.nameKeyArray;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TCMeetingRoomContactsTitleView *view = [[TCMeetingRoomContactsTitleView alloc] init];
    if (section == 0 && self.nameKeyArray.count && [self.nameKeyArray[0] isEqualToString:@"*"]) {
        view.title = @"常用联系人";
    } else {
        view.title = self.nameKeyArray[section];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *nameKey = self.nameKeyArray[indexPath.section];
    NSArray *array = self.participantArrayDict[nameKey];
    TCMeetingParticipant *participant = array[indexPath.row];
    if (participant.isSelected) {
        [self.selectedParticipantDict removeObjectForKey:participant.phone];
    } else {
        [self.selectedParticipantDict setObject:participant forKey:participant.phone];
    }
    participant.selected = !participant.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleClickSaveButton {
    if ([self.delegate respondsToSelector:@selector(meetingRoomAddContactsViewController:didClickSaveButtonWithSelectedParticipantDict:)]) {
        [self.delegate meetingRoomAddContactsViewController:self didClickSaveButtonWithSelectedParticipantDict:self.selectedParticipantDict];
    }
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
