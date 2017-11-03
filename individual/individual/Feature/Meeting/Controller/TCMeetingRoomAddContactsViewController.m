//
//  TCMeetingRoomAddContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddContactsViewController.h"

#import "TCMeetingRoomAddContactsViewCell.h"

#import <TCCommonLibs/TCCommonButton.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>

@interface TCMeetingRoomAddContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *participantArray;

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
    self.participantArray = [NSMutableArray array];
    
    [self setupSubviews];
    [self loadContacts];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
//    tableView.estimatedRowHeight = 0;
//    tableView.estimatedSectionHeaderHeight = 0;
//    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomAddContactsViewCell class] forCellReuseIdentifier:@"TCMeetingRoomAddContactsViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCommonButton *saveButton = [TCCommonButton buttonWithTitle:@"确  定"
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
    [self.participantArray removeAllObjects];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    
    //用户允许访问数据
    //判断是否授权
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) { //授权成功
                //获取联系人仓库
                CNContactStore *store = [[CNContactStore alloc]init];
                //创建联系人信息的请求对象
                NSArray *keys = @[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey];
                //根据请求key，获取请求对象
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                //发送请求
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    //获取姓名
                    NSString *givenName = contact.givenName;
                    NSString *familyName = contact.familyName;
                    
                    //获取电话
                    NSArray *phoneArray = contact.phoneNumbers;
                    for (CNLabeledValue *labelValue in phoneArray) {
                        CNPhoneNumber *number = labelValue.value;
                        
                        TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
                        participant.name = [NSString stringWithFormat:@"%@%@", familyName, givenName];
                        participant.phone = number.stringValue;
                        
                        [weakSelf.participantArray addObject:participant];
                    }
                }];
                [weakSelf.tableView reloadData];
            }else{
                [MBProgressHUD showHUDWithMessage:@"授权失败"];
            }
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusDenied){
        //用户拒绝访问通讯录
        
    }else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined){
        //尚未选择了一个关于是否应用程序可以访问联系人数据
        
    }else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusRestricted){
        //应用程序未被授权访问联系人数据。*用户不能更改该应用程序的状态,可能由于活跃的限制,如家长控制
        
    }
    
#else
    
    //这个变量用于记录授权是否成功，即用户是否允许我们访问通讯录
    int __block tip = 0;
    //声明一个通讯簿的引用
    ABAddressBookRef addBook = nil;
    //创建通讯簿的引用
    addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //创建一个出事信号量为0的信号
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool granted, CFErrorRef error) {
        //granted 为YES 是表示用户允许，否则为不允许
        if (!granted) {
            tip = 1;
        }
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    
    //等待信号触发
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    if (tip) {
        //用户没有允许访问通讯录的提示
        [MBProgressHUD showHUDWithMessage:@"您未允许访问通讯录"];
        return;
    }
    
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex peopleNumber = ABAddressBookGetPersonCount(addBook);
    for (int i = 0; i < peopleNumber; i++) {
        //获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            
            TCMeetingParticipant *participant = [[TCMeetingParticipant alloc] init];
            participant.name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            participant.phone = phone;
            
            [self.participantArray addObject:participant];
        }
        //读取照片
//        NSData *image = (__bridge NSData *)(ABPersonCopyImageData(people));
    }
    
    [weakSelf.tableView reloadData];
#endif
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.participantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomAddContactsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomAddContactsViewCell" forIndexPath:indexPath];
    TCMeetingParticipant *participant = self.participantArray[indexPath.row];
    cell.participant = participant;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Actions

- (void)handleClickSaveButton {
    
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
